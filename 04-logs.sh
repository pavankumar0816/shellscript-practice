#!/bin/bash

userid=$(id -u)
logs_folder="/var/log/shell-script"
logs_file="$logs_folder/$0.log"

mkdir -p $logs_folder

if [ $userid -ne 0 ]; then
   echo "Please run as root user" | tee -a $logs_file
   exit 1
fi

validate () {
    if [ $1 -ne 0 ]; then
        echo "$2 is failed" | tee -a $logs_file
        exit 1
    else
        echo "$2 is Success" | tee -a $logs_file
    fi  
}

dnf install nginx -y  | tee -a $logs_file
validate $? "Nginx Installation"

dnf install mysql -y &>> $logs_file
validate $? "Mysql Installation"
