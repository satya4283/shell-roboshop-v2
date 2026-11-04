app_name=catalogue
source ./common.sh

app_setup
nodejs_setup
systemd_setup


cp "$scripts_dir/mongo.repo"  /etc/yum.repos.d/mongo.repo &>> $logs_file
validate $? "Adding  mongo repo"

dnf install mongodb-mongosh -y &>> $logs_file
validate $? "Installing mongodb client"

product_count=$(mongosh --host "mongodb.$domain_name" --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()') &>> $logs_file
validate $? "Connecting to MongoDB"

if [ $product_count -eq 0 ];then
    mongosh --host "mongodb.$domain_name" </app/db/master-data.js &>> $logs_file
    validate $? "Loading products"
else    
    echo -e " $(timestamp) [INFO] Products already loaded.. ${Y}SKIPPING${N}"
fi

restart
total_time

