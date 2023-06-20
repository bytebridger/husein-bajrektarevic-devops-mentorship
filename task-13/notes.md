#### Uvodni dio

- Cilj [ovog workshop-a](https://catalog.us-east-1.prod.workshops.aws/workshops/752fd04a-f7c3-49a0-a9a0-c9b5ed40061b/en-US/introduction) bio je dobiti hands-on iskustvo sa AWS Code servisima: 
    - AWS CodeCommit kao Git repozitorij
    - AWS CodeArtifact kao menadzovan artifakt repozitorij
    - AWS CodeBuild kao nacin da se pokrenu testovi i naprave softver paketi
    - AWS CodeDeploy kao softver deplojment servis.
    - AWS CodePipeline - servis gdje kreiramo automatiziran CI/CD pipeline.

- Pri prolasku kroz ove servise kreirao sam CI/CD pipeline za Java aplikaciju koja je deployana na EC2 Linux instancu. Kao dodatni bonus radio sam kroz AWS Cloud9 koji je cloud-based integrisan development environment (IDE) koji nam dopusta da pisemo, pokrenemo i debugiramo nas kod unutar web browsera.

#### Postavljanje environment-a kroz Cloud9 servis

![cloud-9](/task-13/screenshots/01-cloud-9-created.png)

#### Maven instalacija

- Maven je build automation tool koji nam treba za Java projekte, koristimo ga kako bi inicijalizirali nasu aplikaciju i upakirali je u Web Application Archive (WAR) fajl.

```
sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
```

![cloud-9-installation](/task-13/screenshots/02-installed-maven.png)

#### Java instalacija

- U ovom slucaju instaliramo Amazon Correto 8 koji je free, production-ready distribution Open Java Development Kit (OpenJDK) provajdan od strane Amazona.

```
sudo amazon-linux-extras enable corretto8
sudo yum install -y java-1.8.0-amazon-corretto-devel
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64
export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH
```
- Provjera:

```
java -version
mvn -v
```

![cloud-9-installation](/task-13/screenshots/03-installed-java.png)

#### Generisemo sample app 

- Pri generisanju sampole app koristimo `mvn` komandu:

![cloud-9-installation](/task-13/screenshots/04-installed-sample-app.png)

## LAB 1 - AWS CodeCommit

- AWS CodeCommit je secure, highly scalable, menadzovan source control servis koji hostuje privatne Git repozitorije. CodeCommit elimira potrebu da sami menadzujemo source control system ili skaliramo njegovu infrastrukturu.

- U ovom labu smo setovali CodeCommit repozitorij gdje smo spremili nas Java code. Prvo smo kreirali CodeCommit repozitorij pa smo onda push-ali code sa Code9 servisa.

![CodeCommit](/task-13/screenshots/06-codecommit-code.png)
![CodeCommit](/task-13/screenshots/05-git-config-pushed-code.png)

## LAB 2 - AWS CodeArtifact

- AWS CodeArtifact je fully managed artifact repozitorij servis koji nam omogucava da na siguran nacin dohvatimo, spremimo, objavimo ili podijelimo software packages koje koristimo u nasem software development procesu.

- U ovom labu smo setovali CodeArtifact repozitorij koji cemo koristiti kasnije tokom build faze sa CodeBuild koji ce fetchovati Maven pakete iz public repozitorija (Maven Central Repository).

- Provjera da se aplikacija moze kompajlirati:

```
mvn -s settings.xml compile
```

![CodeArtifact](/task-13/screenshots/07-successfully-compiled.png)
![CodeArtifact](/task-13/screenshots/08-unicorn-packages.png)

## LAB 3 - AWS CodeBuild

- AWS CodeBuild je fully managed CI servis koji kompajlira source code, runira testove i kreira software packages koji su spremni za deployment. U ovom labu smo setovali CodeBuild projekt gdje smo upalirali nas aplikacijski kod u Java Web Application Archive (WAR) fajl.

![CodeBuild](/task-13/screenshots/09-codebuild-created.png)
![CodeBuild](/task-13/screenshots/10-codebuild-succeeded.png)
![CodeBuild](/task-13/screenshots/11-s3-artifact.png)

## LAB 4 - AWS CodeDeploy

- AWS CodeDeploy je fully managed deployment servis koji automatizira software deployments prema raznim compute servisima kao sto su EC2 instance, AWS Fargate, AWS Lambda ili prema on-premise servisima. U ovom labu koristimo CodeDeploy da instaliramo nase Java WAR pakete na Amazon EC2 instancu koja runnira Apache Tomcat web server.

![CodeDeploy](/task-13/screenshots/12-cloudformation-unicorn-stack.png)
![CodeDeploy](/task-13/screenshots/13-codedeploy-added-files.png)
![CodeDeploy](/task-13/screenshots/14-codebuild-added-scripts-files.png)
![CodeDeploy](/task-13/screenshots/15-created-deployment-group.png)
![CodeDeploy](/task-13/screenshots/16-codedeploy-succeeded-deployment.png)
![CodeDeploy](/task-13/screenshots/17-web-browser-deployment.png)

## LAB 5 - AWS CodePipeline

- AWS CodePipeline je fully managed CD servis koji nam omogucava da automatiziramo pipeline za brzi update aplikacije ili infrastrukture. U ovom labu koristimo CodePipeline da kreiramo automatizirani pipeline koji koristi CodeCommit, CodeBuild i CodeDeploy komponente koje smo kreirali ranije. Pipeline ce biti trigerovan kada se push-a novi commit na main branch naseg Git repo-a.

- U drugom dijelu lab-a pipeline je prosiren tako sto se unaprijedio kod aplikacije i dodao na isti, te preko SNS-a su dodane email notifikacije za approval koda na produkcijski server.

![CodePipeline](/task-13/screenshots/18-codepipeline-first-succeeded.png)
![CodeDeploy](/task-13/screenshots/19-updated-cloudformation.png)
![CodeDeploy](/task-13/screenshots/20-confirmed-sns-subscription.png)
![CodeDeploy](/task-13/screenshots/21-approval-email.png)
![CodeDeploy](/task-13/screenshots/22-pipeline-end.png)
![CodeDeploy](/task-13/screenshots/23-app-end.png)



