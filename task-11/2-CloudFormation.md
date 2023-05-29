## AWS CloudFormation

- U ovom modulu workshop-a koristiti cemo `AWS CloudFormation` da postavio nasu aplikaciju i infrastrukturu asociranu sa istom. Iskoristiti cemo i `AWS Elastic Beanstalk` da pojednostavimo neke stvari. 

![eb-arhitektura](/task-11/img/EB-architecture-GitFlow.png)

#### NA MASTER BRANCH - ELASTIC BEANSTALK

- Da pojednostavimo proces podesavanja i konfigurisanja EC2 instanci, u ovom tutorialu cemo 'zavrtiti' nodejs environment koristeci AWS Elastic Beanstalk - koji ce dopustiti da lako hostujemo web aplikacije bez potrebe da lansiramo, konfigurisemo ili operiramo virtuelnim serverima na svoju ruku. Automatski provizionira i operira infrastrukturom (primjer virtuelnim serverima, load balancerima itd.) i provide-a aplikacijski stack (primjer operativni sistem, programski jezik i framework, web i aplikacijski server itd.) za nas.

#### STAGE 1 - KREIRATI CODE COMMIT REPOZITORIJ

- U ovom koraku cemo napraviti kopiju aplikacijskog koda i kreirati code commit repozitorij koji ce hostovati nas kod.

```
$ aws codecommit create-repository --repository-name gitflow-workshop --repository-description "Repository for Gitflow Workshop"
```

```
$ git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/gitflow-workshop
```

![kreiranje-codecommit-repoa](/task-11/img/kreiranje-codecommit-repoa.PNG)

- Potvrda da je repozitorij kreiran u AWS management konzoli:

![codecommit-kreiran](/task-11/img/codecommit-kreiran.PNG)

#### STAGE 2 - DOWNLOAD THE SAMPLE CODE AND COMMIT YOUR CODE TO THE REPOSITORY

- Download the sample app archive by running the following command:

```
$ ASSETURL="https://static.us-east-1.prod.workshops.aws/public/442d5fda-58ca-41f0-9fbe-558b6ff4c71a/assets/workshop-assets.zip"; wget -O gitflow.zip "$ASSETURL"
```
- Unarchive and copy all the contents of the unarchived folder to your local repo folder: 

```
$ unzip gitflow.zip -d gitflow-workshop/
```
![sample-app-archive](/task-11/img/sample-app-archive.PNG)

- Promijeniti direktrij u nas lokalni repo folder i pokrenuti git add:

```
$ cd gitflow-workshop
$ git add -A
```

- Zatim pokrecemo `git commit` kako bi commit-ali izmjene i push-ali u master granu:

```
$ git commit -m "initial commit"
$ git push origin master
```
![git-commit](/task-11/img/git-commit.PNG)

#### CREATE ELASTIC BEANSTALK APPLICATION

- Da koristimo EB prvo cemo kreirati aplikaciju koja predstavlja nasu aplikaciju unutar AWS-a. U EB-u aplikacija je bukvalno kontejner za environment u kojem runira nasa web aplikacija. Tu se takodjer nalaze verzije web applikacijskog source code-a, konfiguracije, logovi i drugi artefakti koje kreiramo dok koristimo EB.

- Pokrenuti cemo template ispod kako bi kreirali EB application i S3 Bucket za artifakte. Bitna napomena - EB aplikaciju mozemo posmatrati kao folder koji sadrzava komponente naseg Elastic Beanstalk-a dok S3 bucket za artifakte je mjesto gdje cemo postaviti nas aplikacijski code prije deploymenta.

```
$ aws cloudformation create-stack --template-body file://appcreate.yaml --stack-name gitflow-eb-app
```

- Kada pokrenemo ovu komandu AWS CloudFormation pocinje kreiranje resursa koji su specificirani u templateu. Nas novi stack `gitflow-eb-app` se pojavljuje na listi unutar CloudFormation konzole.

![gitflow-eb-app-cf](/task-11/img/gitflow-eb-app-cf.PNG)

- Nakon toga idemo u Elastic Beanstalk konzolu da viidmo aplikaciju koja je kreirana.

![eb-app](/task-11/img/eb-gitflow-app.PNG)

#### MASTER ENVIRONMENT 

- Sada kreiramo AWS Elastic Beanstalk Master Environment. Mozemo deploy-ati vise environments ako zelimo da runiramo vise verzija aplikacije. Naprimjer, mozemo imati development, integracijski i produkcijski environment. 

- Iskoristiti cemo AWS CloudFormation template da set-ujemo elastic beanstalk application i codepipeline da odrade "auto store" nasih artefakata:

```
$ aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters.json --capabilities CAPABILITY_IAM --stack-name gitflow-eb-master
```

- Screenshoti nakon kreiranog stack-a: 

![stack-1](/task-11/img/cf-stack-1.PNG)
![stack-2](/task-11/img/cf-stack-2.PNG)


- Primjer deployane nodejs aplikacije kojoj se moze pristupiti preko linka iz AWS Elastic Beanstalk Environment Management Console. 

![stack-3](/task-11/img/cf-stack-3.PNG)

#### AWS CodePipeline

- AWS CodePipeline je continuous delivery servis koji mozemo koristiti da modeliramo, vizualiziramo i automatiziramo korake potrebne da release-amo nas software. Mozemo brzo modelirati i konfigurisati razlicite stadije software release processa. CodePipeline automatizira korake koji su potrebni da se odradi release naseg softvera kontinuirano.

- Prethodni CloudFormation template je takodjer kreirao i konfigurisao jednostavan AWS CodePipeline sa tri akcije: source, build i deploy. 

![stages-codepipeline](/task-11/img/code-pipeline.png)
![pipeline-succeeded](/task-11/img/pipeline-succeeded.PNG)

#### LAMBDA

- Lambda je compute servis koji nam dopusta da runiramo kod bez provizioniranja ili menadzovanja servera.

![lambda](/task-11/img/lambda.png)

#### LAMBDA CREATION

Configure CodeCommit 

```
$ aws cloudformation create-stack --template-body file://lambda/lambda-create.yaml --stack-name gitflow-workshop-lambda --capabilities CAPABILITY_IAM
```

- Kreirane Lambda funkcije

![lambda-functions](/task-11/img/lambda-created.PNG)

#### AWS CODECOMMIT TRIGGER

- You can configure a CodeCommit repository so that code pushes or other events trigger actions, such as sending a notification from Amazon Simple Notification Service (Amazon SNS) or invoking a function in AWS Lambda. 

- Triggers are commonly configured to:
    - Send emails to subscribed users every time someone pushes to the repository.
    - Notify an external build system to start a build after someone pushes to the main branch of the repository

![triggers](/task-11/img/trigger-notifications.PNG)


#### DEVELOP BRANCH

- Create Develop branch.
- Kada koristimo git-flow extension library, pokretanjem `git flow init` na postojecem repo-u kreiramo develop branch:

```
$ git flow init
```
![develop-branch](/task-11/img/develop-branch.PNG)

- Pushati izmjene na remote repozitorij

![remote-repo](/task-11/img/push-to-develop.PNG)

- Manuelno kreiran development environment za develop branch:

```
aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters-dev.json --capabilities CAPABILITY_IAM --stack-name gitflow-workshop-develop
```

- Screenshot kreiranog environment-a iz CloudFronta:

![cf-develop](/task-11/img/cf-develop-branch.PNG)

- Oba master i develop pipeline:

![master-develop-pipeline](/task-11/img/master-develop-pipeline.PNG)

#### FEATURE BRANCH

- Each new feature should reside in its own branch, which can be pushed to the central repository for backup/collaboration. But, instead of branching off of master, feature branches use develop as their parent branch. When a feature is complete, it gets merged back into develop. Features should never interact directly with master.

- Kreiran feature branch: 

```
git flow feature start change-color
```

- This will automatically do the following:
    - create a new branch named feature/change-color from the develop branch,

#### Create feature branch environment

- Odraditi izmjene vezane za HTML fajl i promjenu boje pozadine.
- Manuelno trigerovana kreacija of the development environmenta:

```
$ aws cloudformation create-stack --template-body file://envcreate.yaml --capabilities CAPABILITY_IAM --stack-name gitflow-workshop-changecolor --parameters ParameterKey=Environment,ParameterValue=gitflow-workshop-changecolor ParameterKey=RepositoryName,ParameterValue=gitflow-workshop ParameterKey=BranchName,ParameterValue=feature/change-color
```

- All three environments active:

![three-environments](/task-11/img/three-environments.PNG)

- Screenshot sa feature grane:

![feature-branch](/task-11/img/feature-branch.PNG)

- Screenshot sa master grane:

![master-branch](/task-11/img/master-version-website.PNG)

#### FEATURE FINISH

- Kada smo verifikovali izmjene koje smo napravili spremni smo merge-ati u develop granu na sljedeci nacin: 

```
$ git flow feature finish change-color
```

![merge-feature](/task-11/img/merge-feature.PNG)

- Sa komandom gore smo merge-ali change-color u develop branch, remove-ali smo feature branch i switch-ovali nazad na develop branch. 

- Sada cemo ukloniti feature granu change-color i pushati izmjene remotely istovremeno:

```
git push origin --delete feature/change-color 
```
![delete-feature](/task-11/img/delete-feature-branch.PNG)

- Commitamo develop branch: 

```
git push --set-upstream origin develop
```

- Posljednje izmjene (sa bojom) su vidljive sada na develop branchu:

![last-changes](/task-11/img/last-changes.PNG)