## Task-8 solution

- [x] Kreiran DNS record husein-bajrektarevic.awsbosnia.com za Hosted Zone awsbosnia.com (Hosted zone ID: Z3LHP8UIUC8CDK) koji ce da pokazuje na EC2 instancu koju sam prethodno kreirao. Za kreiranje DNS zapisa koristio sam AWS CLI sa AWS kredencijalima koji se nalaze unutar excel file-a koji je proslijedjen. AWS CLI konfigurisao sam tako da koristi named profile aws-bosnia koristeci sljedece komande: 

- `aws configure --profile aws-bosnia`
- `aws configure list` → da se provjeri konfiguracija.

- Za ovaj dio taska koristio sam i `change-resource-record-sets` AWS CLI komandu. 

- `aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"husein-bajrektarevic.awsbosnia.com.","Type":"A","TTL":60,"ResourceRecords":[{"Value":"3.72.75.102"}]}}]}'`

- Kada sam dodao novi DNS record njegov Name i Value ispisao uz pomoc komande:

- `aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "husein-bajrektarevic.awsbosnia.com.") | {Name, Value}'`

- ![img-1](/Task-8/screenshots/img-1.PNG) 

- Napomena: 
    - Potrebno je instalirati `jq` tool prije toga:
    - `yum install jq` 

- [x] Na EC2 instanci `ec2-husein-bajrektarevic-task-8` kreirao sam Let's Encrypt SSL certifikat za moju domenu. Omogucio sam da se nodejs aplikaciji moze pristupiti preko linka `https://husein-bajrektarevic.awsbosnia.com`, sto se vidi u browseru sa certifikatom - screenshot ispod.

- ![img-2](/Task-8/screenshots/img-2.PNG)

- [x] Omoguciti autorenewal SSL certifikata

- Uz pomoc sljedece skripte:
    - `SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null` 
    - detaljnije na [certbot dokumentaciji za renewal.](https://eff-certbot.readthedocs.io/en/stable/using.html#setting-up-automated-renewal)

- [x] Koristeci openssl komande prikazao sam koji SSL certitikat koristim i datum njegovog isteka. 

- Komanda:
- `openssl s_client -showcerts -connect husein-bajrektarevic.awsbosnia.com:443`
- Komanda:
- `openssl s_client -showcerts -connect bajrektarevic-husein.awsbosnia.com:443 2>/dev/null | openssl x509 -noout -text`

- [x] Importovao Lets Encrypt SSL certifikat unutar AWS Certified Managera.

- [x] Kreirao Load Balancer gdje sam na nivou Load Balancera koristio SSL cert koji sam ranije importovao. Azurirao `nginx` config fajl kako bi sve radilo kako treba.

- [x] Koristeci openssl komandu prikazao koji SSL certitikat koristim za svoju domenu i datum njegovog isteka.

- `echo | openssl s_client -showcerts -servername husein-bajrektarevic.awsbosnia.com -connect husein-bajrektarevic.awsbosnia.com:443 2>/dev/null | openssl x509 -inform pem -noout -text`

- ![img-3](/Task-8/screenshots/img-3.PNG)

- [x] Kreirao novi SSL certifikat unutar AWS Certified Managera, azurirao ALB da koristi novi SSL cert koji sam kreirao.

- [x] Koristeci openssl komandu prikazao koji SSL certitikat koristim za moju domenu i datum njegovog isteka.

- ![img-4](/Task-8/screenshots/img-4.PNG)

- Dodatno: screenshot sa AWS Certificate Manager-a (ACM) gdje se vidi disabled importovan certifikat i da se koristi Amazon Issued.

- ![img-5](/Task-8/screenshots/img-5.PNG)

- [x] Pri zavrsetku task-a kreirao AMI image pod nazivom `ami-ec2-husein-bajrektarevic-task-8`.
