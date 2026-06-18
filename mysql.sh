#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

userid=$(id -u)

if [ $userid -ne 0 ]; then
    echo -e "$R Please run this script with root user $N" | tee -a $log_file
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]; then
         echo -e " $2  is $R Failed, Please check the log file $N $log_file" | tee -a $log_file
         exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

dnf install mysql-server -y &>>$log_file
validate $? "Installing Mysql"

systemctl enable mysqld &>>$log_file
systemctl start mysqld  
validate $? "Enabled and started mysql"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "Setuped root pass for mysql"