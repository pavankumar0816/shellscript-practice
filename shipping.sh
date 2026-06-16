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

dnf install maven -y &>>$log_file
validate $? "Installed Maven"

