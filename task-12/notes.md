## TASK-12: Packer ⇨ CloudFormation / Terrafrom ⇨ Ansible

- Uvodna napomena: Svi resursi kreirani unutar `eu-central-1` regiona.
- Cilj zadatka je kreirati paralelnu infrastrukturu, jednu koristeci CloudFormation i drugu koristeci Terraform, po dvije EC2 instance koji ce biti web serveri i database serveri.

#### PART 1 - Packer

- Provjeriti packer verziju `$ packer --version` - u slucaju da nije instaliran, instalirati.

- Koristene komande: 

    - Pokrenuti packer komandom `$ packer build packer.json`, instalirati ce i sadrzaj iz skripte `packer-script.sh` koja je ukljucena u `packer.json` fajl.

- Rezultat - kreiran Custom AMI image iz Amazon Linux 3 AMI image-a gdje sam verifikovao da su instalirani `yum repos` koji ce biti iskoristeni kasnije u instalaciji `nginx` web servera i `mysql` baze podataka.

#### PART 2 - CloudFormation

- Koristeci prethodno kreiran AMI, kroz napisan CloudFormation templejt `cf-task-12.yml` kreirati dvije EC2 instance pod nazivom `task-12-web-server-cf` i `task-12-db-server-cf`. Znaci jedna instanca je web server, druga je database server. Za ove instance kroz isti templejt kreirane su dvije security grupe sa potrebnim portovima - unutar defaultnog VPC-a i dva public subneta unutar `eu-central-1` regiona. 

- Napisani templejt uploadovan na CloudFormation servis unutar AWS konzole i pokrenut, uspjesno izvrsen kod iz templejta kreirao dvije instance + dvije security grupe unutar defaultnog VPC-a i dva public subneta.

#### PART 3 - Terraform

- Koristeci prethodno kreiran AMI, kroz napisan Terraform templejt `instances.tf` kreirati dvije EC2 instance pod nazivom `task-12-web-server-tf` i `task-12-db-server-tf`. Znaci jedna instanca je web server, druga je database server. Za ove instance kroz isti templejt kreirane su dvije security grupe sa potrebnim portovima - unutar defaultnog VPC-a i dva public subneta unutar `eu-central-1` regiona. 

- Koristene komande:
    - `terraform init` - za inicijalizaciju novog Terraform direktorija.
    - `terraform plan` - kreira execution plan pokazujuci izmjene koje ce Terraform napraviti na infrastrukturi.
    - `terraform apply` - primjenjuje izmjene definisane unutar Terraform konfiguracije, kreirajuci ili modifikujuci infrastrukturu po potrebi.
    - `terraform destroy` - terminira Terraform-managed infrastrukturu, sve resurse definirane u nasoj konfiguraciji. Ne preporucuje se upotreba u produkcijskom okruzenju.
    - `terraform fmt` - formatira Terraform kod za indentation i consistent style.

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
