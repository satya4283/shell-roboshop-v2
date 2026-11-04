#!/bin/bash

source ./common.sh
check_root

dnf module enable mysql:8.4 -y &>> $logs_file
validate $? "Enable mysql 8.4"

dnf install mysql-server -y &>> $logs_file
validate $? "Install mySQL -server"

systemctl enable mysqld &>> $logs_file
systemctl start mysqld
validate $? " Enable and start Mysql"

mysql_secure_installation --set-root-pass RoboShop@1 
validate $? "setup Mysql root password"


total_time


