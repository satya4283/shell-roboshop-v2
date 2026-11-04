
source ./common.sh

check_root

dnf module disable redis -y &>> $logs_file
dnf module enable redis:7 -y &>> $logs_file
validate $? "Disable and enable redis"

dnf install redis -y &>> $logs_file
validate $? "Install redis"

sed -i  -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "Updated remote connections and protected mode to redis"


systemctl enable redis &>> $logs_file
systemctl start redis 
validate $? "Enable and start redis"

total_time


