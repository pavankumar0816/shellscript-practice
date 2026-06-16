#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

if command -v redis &>/dev/null && redis-server -v | grep -q "v=7"; then
    echo -e "Redis is already installed, $Y Skipping $N" | tee -a $log_file
else
    dnf module disable redis -y &>>$log_file
    validate $? "Disabling redis default version"

    dnf module enable redis:7 -y &>>$log_file
    validate $? "Enabling redis version 7"

    dnf install redis -y &>>$log_file
    validate $? "Installing redis version"
fi

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Allowing Remote Connections"

systemctl enable redis &>>$log_file
systemctl start redis 
validate $? "Enabled and Started redis service"

