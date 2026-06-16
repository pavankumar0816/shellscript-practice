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
      echo -e "$2 is $R Failed... $N" | tee -a $log_file
      exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "Copying Rabbitmq repo"

dnf install rabbitmq-server -y &>>$log_file
validate $? "Installing Rabbitmq Server"

systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server
validate $? "Enabled and started rabbitmq server"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Created rabbitmq user and set permissions"
