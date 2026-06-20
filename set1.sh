#!/bin/bash

set -e

userid=$(id -u)
logs_folder="/var/log/practice"
log_file="$logs_folder/$0.log"

mkdir -p $logs_folder

if [ $userid -ne 0 ]; then
    echo "Run with root user" | tee -a $log_file
    exit 1
fi

for package in $@
do
    dnf list installed $package &>>$log_file
    echo "Package: $package"  

done