## TASK-9 solution

- S3 bucket policy screenshot
![s3-bucket-policy](/Task-9/img/s3-policy.PNG)
- S3 website endpoint screenshot
![s3-endpoint](/Task-9/img/s3-endpoint.PNG)
- Distribution endpoint screenshot
![distr-endpoint](/Task-9/img/distr-endpoint.PNG)
- Final version
![final](/Task-9/img/final.PNG)

## TASK-9 commands

- Route 53 configuration:
    - `aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"www.husein-bajrektarevic.awsbosnia.com","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"d2cqloizpbt2lo.cloudfront.net"}]}}]}'` 
- To check DNS propagation:
    - `aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "www.husein-bajrektarevic.awsbosnia.com.") | {Name, Value}'`

## TASK-9 endpoints

- S3 website endpoint - non-encrypted
    - `http://husein-bajrektarevic-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com`
- CloudFront distribution endpoint - encrypted
    - `https://d2cqloizpbt2lo.cloudfront.net/`
- R53 record - encrypted
    - `https://www.husein-bajrektarevic.awsbosnia.com/`