#/bin/bash

# install yum-utils and download mysql, too.

sudo yum update -y
sudo yum install -y yum-utils
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

