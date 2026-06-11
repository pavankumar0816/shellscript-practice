#!/bin/bash

userid=$(id -u)
log_folder="/var/log/shell-script"
log_file="$log_folder/$0.log"

mkdir -p $log_folder

if [ $userid -ne 0 ]; then
  echo "Run with sudo access" | tee -a $log_file
  exit 1
fi

validate() {
  if [ $1 -ne 0 ]; then
    echo "$2 is failed"  | tee -a $log_file
    exit 1
    else
       echo "$2 is Success"  | tee -a $log_file
  fi 
}


for package in $@
do
    dnf install $package -y &>>$log_file
    validate $? "$package installation"
done

