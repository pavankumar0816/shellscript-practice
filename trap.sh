#!/bin/bash

set -e
trap 'echo "There is an error in $LINENO, Command: $BASH_COMMAND"' ERR

userid=$(id -u)
logs_folder="/var/log/shell-script"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $userid -ne 0 ]; then
  echo -e "$R Run with sudo access $N" | tee -a $log_file
  exit 1
fi

mkdir -p $logs_folder

for package in $@
do
    dnf list installed $package &>> $log_file
    if [ $? -ne 0 ]; then
        echo -e "$Y $package is not installed $N, $G Installing now ... $N" | tee -a $log_file
        dnf install $package -y &>> $log_file
    else
        echo -e "$package is already installed, $Y Skipping now ... $N" | tee -a $log_file
    fi
done