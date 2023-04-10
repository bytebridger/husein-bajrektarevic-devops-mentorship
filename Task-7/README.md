### TASK no. 7

🌐 Description: TASK-7: Autoscaling Group and Load Balancer 🌐

- Task obuhvata:
    - [x] Azuriranje permisija za `IAM 2 User-a` na nacin da se doda u grupu `Administrators`.
    - [x] Kreiranje AMI image-a od instance `ec2-ime-prezime-web-server`. AMI image imenovati `ami-prezime-ime-web-server`.
    - [x] Kreirati Application Load Balancer naziva `alb-web-servers` koji ce biti povezan sa Target Group `tg-web-servers`.
    - [x] Kreirati ASG sa MIN 2 i MAX 4 instance. Tip instance koji cete koristiti unutar ASG je `t2.micro` ili `t3.micro` gdje cemo koristiit `alb-web-servers` Load Balancer. ASG bi trebala da skalira prema gore (scale-up) kad CPU predje `18%` i skalira prema dole (scale down) kad god CPU Utilisation padne ispod `18%`.
    - [x] Security grupe dozvoljavaju najmanje potrebne otvorene portove.
    - [x] Kreiran account na lucidchart.com i napravljen dijagram infrastrukture.
    - [x] Simulirana visoka dostupnost na nacin da su terminirane instance.
    - [x] Simuliran CPU load.

### Screenshots related to task completion:

#### 1 - AMI image

![screenshot-1](/Task-7/img/ami-image.png)

#### 2 - Kreiran ALB koji je povezan sa Target Group.

![screenshot-2](/Task-7/img/created-alb-forward-tg-group.PNG)

#### 3 - Kreiran ASG sa MIN 2 i MAX 4 instance. 

![screenshot-3](/Task-7/img/min2-max4-inst.PNG)

#### 4 Skaliranje - ispod i iznad 18% - Dynamic scaling policies 

![screenshot-4](/Task-7/img/dynamic-scaling.PNG)

![screenshot-5](/Task-7/img/alarm-triggered-policy-scaling.png)

#### 5 Simulirana visoka dostupnost - zamjena unhealthy instanci

![screenshot-6](/Task-7/img/demo-replacing-unhealthy-instance.png)

#### 6 Instaliran `stress` utility - simuliran CPU load  

![screenshot-7](/Task-7/img/cpu-load-simulation.png)

#### 7 Dijagram infrastrukture sa lucidchart.com

![screenshot-8](/Task-7/img/graph.jpeg)

#### 8 DNS Record Load Balancera 

![screenshot-9](/Task-7/img/load-balancer-dns-record.PNG)
[http://alb-web-servers-369594134.eu-central-1.elb.amazonaws.com/](http://alb-web-servers-369594134.eu-central-1.elb.amazonaws.com/)

