#!/bin/bash

userid=$(id -u)
LOGS_FOLDER="/var/log/shellscript"
LOGS_FILE="$LOGS_FOLDER/$0.log"

if [ $userid -ne 0 ]; then
    echo "Run with sudo access" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

validate(){
  if [ $1 -ne 0 ]; then
       echo $2 .. Failed | tee -a $LOGS_FILE
       exit 1
    else
     echo $2 ... Success | tee -a $LOGS_FILE
    fi
}

dnf install nginx -y &>> $LOGS_FILE
validate $? "Nginx Installation"

dnf install mysql -y &>> $LOGS_FILE
validate $? "Mysql Installation"