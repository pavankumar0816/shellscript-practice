#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MYSQL_HOST=mysql.pmpkdev.online

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo -e "$R Please run this script as a root user $N" | tee -a $log_file
   exit 1
fi

mkdir -p $logs_folder

validate(){
    if [ $1 -ne 0 ]; then
      echo -e "$2 is $R Failed... $N" | tee -a $log_file
      exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

dnf install maven -y &>>$log_file
validate $? "Installed Maven"

id roboshop &>>$log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    validate $? "Creating System user"
else
    echo -e "Roboshop user already exists, .. $Y Skipping $N" | tee -a $log_file
fi

mkdir -p /app
validate $? "Creating App Directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>>$log_file
validate $? "Downloading Shipping Content"

cd /app
validate $? "Moving to App Directory"

rm -rf /app/*
validate $? "Removing Existing Code"

unzip /tmp/shipping.zip &>>$log_file
validate $? "Extracting Shipping Content"

cd /app
mvn clean package &>>$log_file
validate $? "Installing and Building Shipping App"

mv target/shipping-1.0.jar shipping.jar 
validate $? "Moving and Renaming Shipping App Jar File"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>>$log_file
validate $? "Created Shipping service file"

systemctl daemon-reload
validate $? "Reloaded"

dnf install mysql -y  &>>$log_file
validate $? "Installing Mysql Client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e "use cities" &>>$log_file
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    validate $? "Loading Shipping Schema"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
    validate $? "Loading Shipping Schema and User Data"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
    validate $? "Loading Shipping Master Data"
else 
    echo -e "Shipping Database already exists ... $Y Skipping $N"
fi

systemctl enable shipping &>>$log_file
systemctl start shipping
validate $? "Enable and Started Shipping service"