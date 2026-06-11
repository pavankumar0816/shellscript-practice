#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo "You must run it as root user"
   exit 1 
fi

validate(){
   if [ $1 -ne 0 ]; then 
      echo "$2 is Failed ...."
      exit 1
   else
       echo "$2 is Success ..."
   fi
}

dnf install  nginx -y
validate $? "Nginx Installation"

dnf install mysqll -y
validate $? "Mysql installation"


remove(){
   
   if rpm -q $1 >/dev/null 2>&1; then
       dnf remove $1 -y
       echo "$1 is removed Successfully"
   else
       echo "$1 is not installed to remove"
       exit 1
   fi
}
remove nginx
remove mysql


