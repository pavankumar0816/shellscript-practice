#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo -e "$R Please run this script as a root user $N" | tee -a $log_file
   exit 1
fi

mkdir -p $logs_folder

validate(){
    if [ $1 -ne 0 ]; then
       echo -e " $2  is $R Failed, Please check the log file $N $log_file" | tee -a $log_file
      exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

dnf module disable nginx -y &>>$log_file
validate $? "Disabling default version"

dnf module enable nginx:1.24 -y &>>$log_file
validate $? "Enabling Nginx 1.24 version"

dnf install nginx -y &>>$log_file
validate $? "Installing nginx"

systemctl enable nginx &>>$log_file
systemctl start nginx 
validate $? "Enabled and started nginx"

rm -rf /usr/share/nginx/html/*  
validate $? "Removing Default Nginx Content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
validate $? "Downloading Frontend App Content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$log_file
validate $? "Extracted Frontend App Content"

rm -rf /etc/nginx/nginx.conf
validate $? "Removing default content"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$log_file
validate $? "Created Nginx Configuration File"

systemctl restart nginx 
validate $? "Restarted Nginx Service"