#!/bin/bash

source ./common.sh
check_root


dnf module disable nginx -y &>>$logs_file
dnf module enable nginx:1.26 -y &>>$logs_file
dnf install nginx -y &>>$logs_file
validate $? "Installing Nginx"

systemctl enable nginx &>>$logs_file
systemctl start nginx &>>$logs_file
validate $? "Enable and start Nginx"

rm -rf /usr/share/nginx/html/* &>>$logs_file
validate $? "Remving old index.html file"

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip &>>$logs_file
validate $? "Download the frontend"

cd /usr/share/nginx/html &>>$logs_file
unzip /tmp/frontend.zip &>>$logs_file
validate $? "Unzip the frontend"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/roboshop.conf"
cp "$scripts_dir/roboshop.conf" /etc/nginx/default.d/roboshop.conf

nginx -t &>>$logs_file
validate $? "Checks for file mistakes"

systemctl restart nginx
validate $? "Restarting Nginx "


total_time