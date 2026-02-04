#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]; then
    echo "Run with sudo access"
    exit 1
fi


validate(){
   if [ $1 -ne 0 ]; then
       echo "$2 ... Failed"
       exit 1
    else
         echo "$2 ... Success"
     fi
}

dnf install nginx -y
validate $? "Nginx Installation"

dnf install mysql -y
validate $? "Mysql Installation"