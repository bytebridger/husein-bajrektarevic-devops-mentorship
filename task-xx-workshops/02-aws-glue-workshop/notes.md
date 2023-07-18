## AWS Glue Studio Workshop

## PART 1 - SETUP

* **AWS Glue** is a serverless data integration service that makes it easy to discover, prepare, and combine data for analytics, machine learning, and application development. AWS Glue provides all of the capabilities needed for data integration so that you can start analyzing your data and putting it to use in minutes instead of months.

* **AWS Glue Studio** is a new graphical interface that makes it easy to create, run, and monitor extract, transform, and load (ETL) jobs in AWS Glue. You can visually compose data transformation workflows and seamlessly run them on AWS Glue’s Apache Spark-based serverless ETL engine.

#### Workshop goal

* This workshop aims to introduce you to the AWS Glue Studio that will make it easier to discover, transform and load your data inside an Amazon S3 bucket.

* We will create a Glue crawler and a Glue job to transform and load our data in an optimized format into an Amazon S3 bucket. We will cover some example transformations such as joining two datasets, modifying field values, dropping unnecessary fields or changing the data type of a field.

#### SETUP and data preparation

* Kreiranje Cloud9 instance
    * Cloud9 → Create environment

* Creating a bucket
    * Koristimo komandu iz workshopa u nasem Cloud9 terminalu kroz skriptu.

![create-workshop](/task-xx-workshops/02-aws-glue-workshop/img/01-create-bucket.png)

* Obtaining Sample data
    * Following command will create a folder in your bucket named "raw/covid_csv/", download the data and put it in your folder. Observe that the data is in CSV format.
    * `$ aws s3api put-object --bucket $BUCKET_NAME --key raw/covid_csv/`
    * `$ aws s3 cp s3://covid19-lake/enigma-jhu-timeseries/csv/ s3://$BUCKET_NAME/raw/covid_csv/ --recursive`

    * Following command will create another folder named "raw/btcusd_csv/". We will use this one later.
    * `$ aws s3api put-object --bucket $BUCKET_NAME --key raw/btcusd_csv/`
    * `$ aws s3api put-object --bucket $BUCKET_NAME --key curated/`

    * Let's go check our Amazon S3 folder. Open the AWS console and search for Amazon S3. There should be a single bucket listed in the S3 console. The name of the bucket should be in the form of "-studio-workshop". Click on it to see the folders we created. Inside the "raw/covid_csv/" folder, we should see our CSV file.
        * Click on the CSV file.
        * On the top right, click on Object actions and choose Query with S3 Select
        * Scroll down and click Run SQL query
    * With S3 Select, you can easily query part of a file in your bucket and see the structure without downloading it.

![s3-sql-query](/task-xx-workshops/02-aws-glue-workshop/img/02-s3-sql-query.png)

* Download Bitcoin Data
    * Now, go back to "raw/" folder and click on "btcusd_csv" folder. We have created this folder with a CLI command that we described above. Currently it is empty.
    * We will upload a file into S3 with bitcoin data we downloaded via instructions from the workshop.

* IAM Roles
    * IAM Console → Roles → Create role.
        * AWS Service [choose Glue]
    * Under permissions select:
        * AWSGlueServiceRole
        * AmazonS3FullAccess
    * Name your role as "GlueStudioWorkshopRole".

## PART 2 - AWS GLUE STUDIO

* Here is a diagram of what we want to achieve:

![diagram](/task-xx-workshops/02-aws-glue-workshop/img/diagram.png)

* Creating a Glue Crawler
    * A crawler is used to populate the AWS Glue Data Catalog with tables. We can create it if we:
    * Open AWS Glue in our AWS Console
    * On the left sidebar, choose Crawlers and Create crawler*.
    * Name: "covid_bitcoin_raw_crawler"

![crawler](/task-xx-workshops/02-aws-glue-workshop/img/03-crawler.png)

* Creating a Glue Job
    * AWS Glue - ETL Jobs
    * Job details - "covid-bitcoin-job"
    * IAM Role - "GlueStudioWorkshopRole"
    * NOTE: GlueStudioWorkshopRole has access to all S3 buckets. This is ok for our workshop. But in a production scenario, you need to be more restrictive about permissions, only allowing necessary operations to specific S3 buckets.
    * Since our datasets are very small, let's use just 2 workers with G.1X. It is more than enough for our case.

![job-details](/task-xx-workshops/02-aws-glue-workshop/img/03-job-details.png)

* Load Covid data from S3
    * Click Add node button ( + ) and then Source - S3. 

![s3-source](/task-xx-workshops/02-aws-glue-workshop/img/04-created-s3.png)

* Drop a column & fix the type of a field
    * Drop "fips" column.
    * Use transform option.

![transform](/task-xx-workshops/02-aws-glue-workshop/img/05-transform.png)

* Write the data into S3 bucket in Parquet format 

![parquet](/task-xx-workshops/02-aws-glue-workshop/img/06-parquet-format-s3.png)

* Load Bitcoin data from S3

![s3-bitcoin](/task-xx-workshops/02-aws-glue-workshop/img/07-s3-bucket-bitcoin.png)

* Write the data into S3 bucket in Parquet format