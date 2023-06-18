## TASK-12: Packer ⇨ CloudFormation / Terrafrom ⇨ Ansible

- Uvodna napomena: Svi resursi kreirani unutar `eu-central-1` regiona.
- Cilj zadatka je kreirati paralelnu infrastrukturu, jednu koristeci CloudFormation i drugu koristeci Terraform, po dvije EC2 instance koji ce biti web serveri i database serveri.

- UPDATE: nakon PR review-a sa [office hours](https://youtu.be/VVjKOrplb4s) implementirao sam predlozene izmjene sa ciljem unapredjenja infrastrukture - dodao sam biljeske o tome u nastavku.

#### PART 1 - Packer

- Provjeriti packer verziju `$ packer --version` - u slucaju da nije instaliran, instalirati.
- **UPDATE - AMI & Region variables:** Dodane varijable za regiju i AMI unutar `packer.json` fajla; Potrebno pokrenuti komandu na sljedeci nacin da se unesu potrebne varijable: 

`$ packer build -var "region=eu-central-1" -var "source_ami=ami-041dc" packer.json`

- Rezultat - kreiran Custom AMI image iz Amazon Linux 3 AMI image-a gdje sam verifikovao da su instalirani `yum repos` koji ce biti iskoristeni kasnije u instalaciji `nginx` web servera i `mysql` baze podataka.

- Vise o Packer varijablama [na ovom linku.](https://developer.hashicorp.com/packer/guides/hcl/variables)

#### PART 2 - CloudFormation

- Koristeci prethodno kreiran AMI, kroz napisan CloudFormation templejt `cf-task-12.yml` kreirati dvije EC2 instance pod nazivom `task-12-web-server-cf` i `task-12-db-server-cf`. Znaci jedna instanca je web server, druga je database server. Za ove instance kroz isti templejt kreirane su dvije security grupe sa potrebnim portovima - unutar defaultnog VPC-a i dva public subneta unutar `eu-central-1` regiona. 

- Napisani templejt uploadovan na CloudFormation servis unutar AWS konzole i pokrenut, uspjesno izvrsen kod iz templejta kreirao dvije instance + dvije security grupe unutar defaultnog VPC-a i dva public subneta.

- **UPDATE - Outbound rules:** Updateovan template na nacin da su modifikovani outbound rules sa ciljem unapredjenja sigurnosti. Za WebServerSecurityGroup outbound rules su uklonjeni u potpunosti dok za DatabaseServerSecurityGroup dodan je outbound rule koji omogucava outbound traffic prema WebServerSecurityGroup na defaultnom MySQL portu 3306. Na ovaj nacin database server komunicira sa web serverom te svaki drugi outbound traffic je denied.  

- Vise o best practice kad su security grupe u pitanju [na sljedecem linku.](https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html)

- **UPDATE - AMI, VPC & Subnet parameters:** - Updateovan kod unutar template-a na nacin da se AMI, defaultni VPC i Subneti dodaju kao parametri prilikom pokretanja unutar CloudFormation servisa.

- **UPDATE - VALIDATE TEMPLATE** - Kada je u pitanju verifikacija template-a koristimo komandu `validate-template`:

`$ aws cloudformation validate-template --template-body file://cf-task-12.yml`

- Prije nego napravimo PR mozemo provjeriti putem ove komande da se radi o validnom `.yml` fajlu;

- **UPDATE - Key pair** - modifikovan kod unutar templejta da krajnji korisnik unese naziv key-a koji ce da se kreira prilikom dizanja infrastrukture. 

#### PART 3 - Terraform

- Koristeci prethodno kreiran AMI, kroz napisan Terraform templejt `instances.tf` (kasnije updateovan naziv fajla na `main.tf`) kreirao dvije EC2 instance pod nazivom `task-12-web-server-tf` i `task-12-db-server-tf`. Znaci jedna instanca je web server, druga je database server. Za ove instance kroz isti templejt kreirane su dvije security grupe sa potrebnim portovima - unutar defaultnog VPC-a i dva public subneta unutar `eu-central-1` regiona. 

- Koristene komande:
    - `terraform init` - za inicijalizaciju novog Terraform direktorija.
    - `terraform plan` - kreira execution plan pokazujuci izmjene koje ce Terraform napraviti na infrastrukturi.
    - `terraform apply` - primjenjuje izmjene definisane unutar Terraform konfiguracije, kreirajuci ili modifikujuci infrastrukturu po potrebi.
    - `terraform destroy` - terminira Terraform-managed infrastrukturu, sve resurse definirane u nasoj konfiguraciji. Ne preporucuje se upotreba u produkcijskom okruzenju.
    - `terraform fmt` - formatira Terraform kod za indentation i consistent style.

- **UPDATE - Terraform file structure** - izmijenjena struktura Terraform fajlova: 
    - konfiguracijski kod se nalazi unutar `config.tf` fajla.
    - kod za infrastrukturu se nalazi unutar `main.tf` fajla.

- **UPDATE - Tags** - dodao tagove koji nam pokazuju da kreirani resursi su menadzovani Terraformom.

- **UPDATE - Created S3 bucket and secured state locking** - State blocking je bitan u timskom radu jer kada inzinjer A radi izmjene na infrastrukturi, inzinjer B u isto vrijeme ne moze mijenjati istu infrastrukturu. Pored toga backend S3 je potreban iz niza drugih sigurnosnih razloga. 

- ***UPDATE - Used `data` to retrieve IDs for the existing subnet from AWS*** - Iskoristen `data` blok da se dobiju informacije o postojecem subnetu i iskoristi u konfiguraciji resursa, u ovom slucaju `aws_subnet` konkretno da se dobiju podaci o subnetu na osnovu njegovog ID-a. Vise o `data` bloku na [sljedecem linku.](https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/subnet_ids)

- **UPDATE - Created EC2 instances using EC2 Instance Terraform module** - kod preuzet sa oficijelnog terraform-aws-modules repozitorija [ovdje.](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/tree/master)

- **UPDATE - Created variables for AMI, VPC, subnet** - because whenever we have a value which should be updated by end-user, it should be placed into variable.

#### PART 4 - Ansible

- IP adrese hostova (prvo web servera, zatim database servera) koje sam smjestio u `inventory.ini` fajl sam izvukao koristeci komandu sa predavanja:
    - `aws ec2 describe-instances --filters "Name=tag:Name,Values=webservers" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

![database-servers-ip](/task-12/05-screenshots/database-servers-ip.png)
![web-servers-ip](/task-12/05-screenshots/public-ips-web-server.png)

- Koristeci ansible provisioner instalirao sam `nginx` web server na `task-12-web-server-cf` i `task-12-web-server-tf` instance. Isto tako koristeci ansible provisioner instalirao sam `mysql` bazu podataka na `task-12-db-server-cf` i `task-12-db-server-tf` instance.

![nginx-up-and-running](/task-12/05-screenshots/nginx-up-running.png)
![mysql-up-and-running](/task-12/05-screenshots/mysql-up-and-running.png)
![installed-mysql-playbook](/task-12/05-screenshots/installed-mysql.png)

- Kroz web server playbook sam napisao kod koji omogucava da instaliran `nginx` je enable-ovan i startovan po automatizmu, isto i `mysql` baza podataka. Nakon toga sam dodao kod koji preko skripti mijenja defaultni sadrzaj `index.html` fajlova na oba web server hosta.  

![hello-1](/task-12/05-screenshots/hello-from-nginx-CF-A.png)
![hello-2](/task-12/05-screenshots/hello-from-nginx-TF-A.png)

- Poslije toga sam napravio playbook koji u `mysql` bazi podataka na oba hosta kreira bazu `task-12-db`, korisnika `task-12-user` sa passwordom `task-12-password` i svim privilegijama na prethodno spomenutoj bazi.

![database-check](/task-12/05-screenshots/database-check.png)

- Na kraju sam napravio odvojeni playbook za task koji verifikuje konekciju preko defaultnog `mysql` database port-a `3306`, po zahtjevu zadatka, od web servera prema database serverima, koristeci `telnet`. 

![connection-succeeded](/task-12/05-screenshots/connectin-succeeded.png)

- Dodatna napomena za koristenje environment varijabli. Za updateovanje baze podataka pred kraj task-a koristio sam variable za passworde koje koriste `lookup` funkciju da vrate vrijednosti iz environment varijabli. Env varijable setujemo preko export komande koju slijedi naziv varijable i vrijednost. Npr.:
    `$ export MYSQL_ROOT_PASSWORD=your-root-password`
    `$ export MYSQL_USER_PASSWORD=task-12-password`

- Koristene komande:
    - `ansible-playbook update-database.yml` - izvrsava playbook pod nazivom update-database.yml

- **UPDATE - Deleted script for MySQL installation and wrote Ansible playbook instead** - I deleted bash script that installs mysql on database servers and wrote Ansible playbook that installs latest version of MySQL database which is also up and running after installation.

- **UPDATE - Dynamic inventory** - wrote playbook that acts as dynamic inventory and pulls out all hosts (for example database-servers) and executes code from the database-server playbook on those hosts. More about dynamic inventory on [this link.](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html#examples)
    - Commands that need to be used with dynamic inventory:
        - ` ansible-inventory -i aws_ec2.yml --list` - lists all hosts within a region and with specified tags.
        - `ansible-playbook -i aws_ec2.yml db-server-playbook.yml --limit 'database_server_group'` - executes `db-server-playbook.yml` on given hosts that are limited to database_server_group tags in this case.
