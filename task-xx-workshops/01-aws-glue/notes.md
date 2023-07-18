## AWS Glue Tutorial

[Youtube video link](https://youtu.be/dQnRP6X8QAU)

#### Course overview

![course-overview](/task-xx-workshops/01-aws-glue/img/01-overview.png)

#### What is AWS Glue?

![aws-glue](/task-xx-workshops/01-aws-glue/img/02-aws-glue-explained.png)

* U potpunosti menadzovan ETL servis koji se sastoji od Central Metadata Repository - pod nazivom Glue Data Catalog.
* Sadrzi Spart ETL Engine koji je u potpunosti serverless.
* Ima Flexible scheduler. 

#### Why do we use AWS Glue?

* AWS Glue offers a fully managed serverless ETL Tool. This removes the overhead, and barriers to entry, when there is a requirement for a ETL service in AWS.

* Napomena - ETL = Extract, Transform, Load - bukvalno data integration process koji kombinira data iz vise data izvora u jedan konsistentan data store koji je loadovan u data warehouse ili drugi target system.

#### Setup work

![setup-work](/task-xx-workshops/01-aws-glue/img/03-setup-work.png)

* KORACI za S3 setup:

    * Ulogujemo se na AWS konzolu → S3 [Create bucket] 
    * Kreirati par direktorija u S3:
        * data
        * temp-dir
        * scripts
    * Unutar data direktorija imamo:
        * customers_database/customers_csv/dataload=180723
    * Dodati cemo `customer.csv` fajl u `dataload` direktorij jer treba nam neki dummy data.

* KORACI za kreiranje IAM Role:

    * IAM servis → Roles → Create Role → Choose AWS Service → Glue
        * Permissions → AdminAccess (napomena - ne preporucuje se na produkciji ali OK je za learning purposes)
        * Role name: `glue-course-husein`

* Dalje prelazimo na upoznavanje sa AWS Glue Data Catalog

#### AWS Glue Data Catalog

![aws-glue-data-catalog](/task-xx-workshops/01-aws-glue/img/04-aws-glue-data-catalog.png)

* Persistent Metadata Store     
    * Metadata moze biti data location, schema, data types, data classification

* AWS Glue Data catalog je u sustini menadzovan servis koji nam dopusta da spremimo, pribiljezimo, pohranimo i podijelimo metadata koji mogu biti iskoristeni da dohvate i transformiraju data.

* Mozemo imati jedan AWS Glue Data Catalog po AWS regiji. 

* Identity and Access Management (IAM) policies kontrolisu pristup.

* Moze biti koristen za data governance (upravljanje podacima). 

* Unutar AWS konzole za pristup AWS Glue Data Catalog-u: 

    * Search AWS Glue i mozemo da vidimo samu sustinu Glue-a:
        *  Data catalog → Databases → Crawlers → Schemas

![glue-dashboard](/task-xx-workshops/01-aws-glue/img/05-aws-glue-console.png)

* Sada cemo vidjeti sta su databases i kako mozemo koristiti crawler da kreiramo database table.

#### AWS Glue Databases

![aws-glue-db](/task-xx-workshops/01-aws-glue/img/06-aws-glue-db.png)

* AWS Glue database je set povezanih Data Catalog tabela organiziranih u logicku grupu.

* Kreiranje baze kroz konzolu:

    * Data catalog → Databases → Add database → `customers_database`
    * Napomena - prilikom naming konvencije uvijek koristiti underscore `_` zbog Spark engine-a.

![glue-db](/task-xx-workshops/01-aws-glue/img/07-glue-database.png)

* Sad kad imamo database setovan mozemo kreirati tables.

#### AWS Glue Tables

![glue-tables](/task-xx-workshops/01-aws-glue/img/08-aws-glue-tables.png)

* Glue Tables sadrze metadata definicije koje predstavljaju nas data. Koncept koji bi trebali razumjeti prije nego kreiramo ove tables je vezan za particije unutar AWS-a.

#### Partitions in AWS

![partitions-aws](/task-xx-workshops/01-aws-glue/img/09-partitions-in-aws.png)

* Direktoriji gdje data je pohranjen na S3, koji su fizicki entiteti, su mapirani na particije koje su logicki entiteti, npr. columns unutar Glue table-a.

* Naprimjer, unutar naseg direktorija `customers_database` imamo `customers_csv` direktorij koji sadrzi particiju `dataload` koja je zapravo fizicka particija kao direktorij od koje cemo dobiti dataload column i vrijednost koju ce taj column sadrzavati ce odnositi se na datum koji smo setovali u nazivu direktorija. 

* Sa primjera na slici vidimo kako pisemo query za data:
    
    * `s3://sales/year=2019/month=Jan/day=1` → znaci query prolazi kroz sales direktorij, year direktorij, month direktorij i day=1 direktorij, ignorisuci sve ostale direktorije zbog particija.

* Znaci particije su samo direktoriji unutar S3 koji nam pomazu prilikom data query-a.

#### AWS Glue Crawlers

![glue-crawlers](/task-xx-workshops/01-aws-glue/img/10-crawlers.png)

* Crawler is a program that connects to a data store (source or target), progresses through a prioritized list of classifiers to determine the schema for your data, and then creates metadata tables in the AWS Glue Data Catalog.

#### Create Table in the Glue Data Catalog

* Data catalog → Databases → `customers_database` → Add table
    * Ovdje imamo opciju da dodamo table koristeci crawler ili manually.

* Prije nego dodamo tabelu koristeci crawler, dodati cemo tabelu manuelno.

* STEP 1
    * Unosimo naziv tabele → `test_customer_csv`
    * Selektujemo nasu bazu podataka.
    * Data store → selektujemo S3 → unosimo path do nase baze: `s3://husein-glue-course/data/customers_database`
    * Data format - selektujemo `.csv`, tj. format u kojem se nalazi nas data.

* STEP 2
    * Choose or define schema 
    * Selektujemo Schema → Add
    * Column 1 → Name: dataload → Data Type: smallint
    * Column 2 → Name: customer_id → Data Type: smalling 
        * for this one we used information from `customers.csv`

![define-schema](/task-xx-workshops/01-aws-glue/img/11-define-schema.png)

* Vidimo koliko zapravo ima posla da se rucno unose podaci, da bi sebi olaksali zivot mozemo koristiti `crawler` koji ce to automatski odraditi za nas. Izaci cemo iz ovog dijela i necemo snimiti nasu schemu nego cemo ponovo ici na proces dodavanja tabele ali ovaj put koristeci → `Add tables using crawler` opciju.

* Nakon sto imenujemo nas crawler selektujemo `Add data source` opciju gdje dodajemo S3 data source:
    * `s3://husein-glue-course/data/customers_database/customers_csv`

* Dalje, selektujemo IAM Role koji smo prethodno kreirali, zatim database i kliknemo na Create crawler.

![create-crawler](/task-xx-workshops/01-aws-glue/img/12-create-crawler.png)

* Unutar `Crawlers` oznacimo nas crawler i kliknemo na run.
* Ako odemo na AWS Glue → Tables → customers_csv vidjeti cemo da je crawler pokupio column names:

![column-names](/task-xx-workshops/01-aws-glue/img/13-column-names.png)

* Ako kliknemo na partitions vidimo particiju isto i ako zelimo vidjeti data → kliknemo Actions → View data → redirectovati ce nas na Athenu.

* Prije toga cemo kreirati novi direktorij u nasem S3 bucketu pod nazivom `athena_results`, zatim selektujemo taj direktorij i kopiramo S3 URI: `s3://husein-glue-course/athena_results/`

* Zatim idemo nazad na Editor u Atheni i kliknemo na Tables → customers_csv → Preview table.

![table-preview-athena](/task-xx-workshops/01-aws-glue/img/14-athena-preview.png)

* Prije nego predjemo na kreiranje AWS Glue job-a trebali bi provjeriti sta su AWS Glue connections. 

#### AWS Glue connections

![aws-glue-connections](/task-xx-workshops/01-aws-glue/img/15-aws-glue-connections.png)

* Glue connections su zapravo Data Catalog objekat koji sadrzi properties potrebni za konektovanje na odredjeni data store.

#### AWS Glue Jobs

* The business logic that is required to perform ETL work. It is composed of a transformation script, data sources, and data targets. Job runs are initiated by triggers that can be scheduled or triggered by events. 

![aws-glue-jobs](/task-xx-workshops/01-aws-glue/img/16-aws-glue-jobs.png)

* AWS Glue → Data integration and ETL → ETL jobs