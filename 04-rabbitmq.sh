source ./common.sh

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "Installing RabbitMQ Server"

systemctl enable rabbitmq-server &>> $logs_file
systemctl start rabbitmq-server &>> $logs_file
validate $? "Enable and start rabbitMQ"


sudo rabbitmqctl list_users | grep -qw roboshop 
if [ $? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123 &>> $logs_file
    validate $? "Create RabbitMQ user for roboshop."
else    
    echo -e "$(timestamp) [INFO] Roboshop user already exist...${Y}SKIPPING${N}"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logs_file
validate $? "Setting the permissions for RabbitMQ."


total_time


