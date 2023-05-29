## Task-11

- To complete this task I have completed [AWS Tools GitFlow Workshop.](https://catalog.us-east-1.prod.workshops.aws/workshops/484a7839-1887-43e8-a541-a8c014cd5b18/en-US)

- My resources were created in `eu-central-1` as part of the task requirements.

- The main point of this task was to learn about high-level framework for how to implement GitFlow using AWS CodePipeline, AWS CodeCommit, AWS CodeBuild and AWS CodeDeploy. I've also had the opportunity to walk through a prebuilt example and examine how the framework can be adopted for individual use cases. 

![GitFlow-animation](/task-11/img/gitflow-workshop.gif)

## 1 UVOD

#### Branching models

- Imamo dva popularna branching modela koje klijenti implementiraju u svojim organizacijama. Jedan je **Trunk Based** model dok je drugi **Feature-based** ili **GitFlow** model. 

#### Trunk-based development

- Unutar Trunk-based modela, developeri suradjuju unutar jednog branch-a ili trunk-a. Ovo vodi prema izbjegavanju kompleksnosti merge-anja. Ovaj model je preporucen timovima unutar Amazona i praksa je da se radi Continuous Integration preko trunk-based developmenta.

#### Feature-based aka GitFlow development

- Razlozi zasto se koristi ovaj model je sto vise timova moze raditi na razlicitim feature release-ima sa razlicitim timeline-ima. Pojedine organizacije koje pruzaju SAAS (Software As-A Service) mozda imaju klijente koji ne zele biti na "latest" verzijama sve vrijeme sto ih forsira da kreiraju nekoliko "Release" i "Hotfix" brancheva. Neki timovi mozda imaju specificne QA zahtjeve - primjer manual approval sto dovodi do delay-a prilikom release-a u produkciju.

#### GitFlow

- Ukljucuje nekoliko level-a branching-a sa master grane gdje promjene na feature branches su samo periodicno merge-ane na master granu i gdje trigger-uju release.
- U ovom slucaju `Master` grana uvijek sadrzi produkcijski kod.
- `Develop` grana sadrzi novi development kod.
- Ove dvije grane su tzv. `long-running branches` - one ostaju u nasim projektima sve vrijeme, dok druge grane, za neke features ili releases, postoje samo privremeno - kreiraju se po potrebi i uklonjene su nakon sto su ispunile svoju svrhu. 

#### GitFlow guidelines:

- Use `development` as a continuous integration branch.
- Use feature branches to work on multiple features.
- Use release branches to work on a particular release (multiple features).
- Use hotfix branches off master to push a hotfix.
- Merge to master after every release.
- Master contains production-ready code. 

![gitflow-only](/task-11/img/gitflow-only.png)

- Vise informacija na [branching model](https://nvie.com/posts/a-successful-git-branching-model/) clanku.

## 2 KREIRANJE WORKSPACE-a

- Otvaramo `AWS Cloud9` konzolu na svom AWS racunu, selektujemo `Create environment` i imenujemo `gitflow-workshop`, sve ostale opcije ostavljamo po defaultu.
- Kada se kreira environment, mozemo zatvoriti `welcome tab` i `lower work area` i potom otvoriti `terminal`.

![screen-1](/task-11/img/screen-1.PNG)

#### AWS CLOUD9 IDE

- AWS Cloud9 je cloud-based integrisan development environment (IDE) koji nam dopusta da pisemo, run-ujemo i debug-ujemo kod ubutar web browsera.

- Po defaultu Amazon EBS koji je attached na Cloud9 instancu je 10 GiB, da provjerimo mozemo kucati `df -h` komandu i vidjet cemo da `/dev/xvda1` je 10 GiB sa 4.3 GiB dostupnog prostora u mom slucaju. Ovo nije dovoljno slobodnog prostora i trebamo resize-ovat space da run-iramo ovaj workshop.

- Unutar Cloud9 terminala kreiramo fajl `resize.sh`:

```
$ touch resize.sh
```
- Otvaramo `resize.sh` i paste-ujemo [skriptu](https://catalog.us-east-1.prod.workshops.aws/workshops/484a7839-1887-43e8-a541-a8c014cd5b18/en-US/introduction/access-cloud9) iz dokumentacije.

- Kucamo komandu koja ce pokrenuti skriptu `resize.sh` i promijeniti velicinu attachovanog EBS-a na 30 GiB.

```
bash resize.sh 30
```
![output-skripte](/task-11/img/output-skripte.PNG)

- Provjera velicine attachovanog EBS volume-a:

![new-size](/task-11/img/30GB.PNG)

#### INITIAL SETUP

- Sad kad imamo disk od 30 GiB mozemo odraditi inicijalni setup koristeci `git config` komandu gdje cemo setovati nas `git user.name` i `git user.email` koristeci sljedece komande:

```
$ git config --global user.name "b-husein"
$ git config --global user.email "bajrektarevic.husein@gmail.com"
```

- Sad konfigurisemo AWS CLI Credential Helper kojim manage-ujemo kredencijale za konektovanje na nas CodeCommit repozitorij. AWS Cloud9 development environment dolazi sa AWS managed privremenim kredencijalima koji su dodijeljeni nasem IAM useru. Koristimo te kredencijale sa AWS CLI credential helper koji dozvoljava Gitu da koristi HTTPS & cryptographically signed version nasih IAM user kredencijala ili Amazon EC2 instance role kadgod Git treba da se autentificira sa AWSom kako bi imao interakciju sa CodeCommit repozitorijima.

- Za konfiguraciju AWS CLI Credential helper-a za HTTPS konekciju koristimo sljedece dvije komande: 

```
$ git config --global credential.helper '!aws codecommit credential-helper $@'
$ git config --global credential.UseHttpPath true
```

- Screenshot izvrsenih komandi: 

![git-config-komande](/task-11/img/git-config-komande.PNG)

- Zatim instaliramo `gitflow` koji je kolekcija Git extenzija koje omogucavaju high-level repository operacije za prethodno spomenuti Vincent Driessen's branching model:

```
$ curl -OL https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh
$ chmod +x gitflow-installer.sh
$ sudo git config --global url."https://github.com".insteadOf git://github.com
$ sudo ./gitflow-installer.sh
```

- Screenshot izvrsenih komandi:

![gitflow-install](/task-11/img/gitflow-install.PNG)

