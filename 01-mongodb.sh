#!/bin/bash
source ./common.sh
check_root


cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "Install MongoDB"

systemctl enable mongod
systemctl start mongod
validate $? "enable and start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "update remote connections to MongoDB"

systemctl restart mongod
validate $? "restart MongoDB"

total_time

