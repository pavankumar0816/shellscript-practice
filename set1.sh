#!/bin/bash

set -e

userid=$(id -u)
logs_folder="/var/log/practice"
log_file="$logs_folder/$0.log"

if [ $userid -ne 0 ]; then
    echo "Run with root user"
    exit 1
fi

for package in $@
do
    dnf list installed $package
    
done