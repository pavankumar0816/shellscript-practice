#!/bin/bash

userid=$(id -u)
logs_folder="/var/log/shell-script"
logs_file="$logs_folder/$0.log"

mkdir -p $logs_folder



if [ $userid -ne 0 ]; then
   echo "Please run as root user"
fi

validate () {
    if [ $1 -ne 0 ]; then
        echo "$2 is failed"
        exit 1
    else
        echo "$2 is Success"
    fi  
}

dnf install nginx -y &>> $logs_file
validate $? "Nginx Installation"

dnf install mysql -y &>> $logs_file
validate $? "Mysql Installation"
