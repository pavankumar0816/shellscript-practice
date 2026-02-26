#!/bin/bash

set -e #This will be checking the error in each command and if any command fails it will exit the script

#!/bin/bash

userid=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"

if [ $userid -ne 0 ]; then
   echo "Please run this script with root user access" | tee -a $LOGS_FILE
   exit 1
fi

mkdir -p $LOGS_FOLDER

validate(){
   if [ $1 -ne 0 ]; then
        echo "$2 is failure" | tee -a $LOGS_FILE
        exit 1
    else
        echo "$2 is success" | tee -a $LOGS_FILE
    fi 
}

for package in $@ # sudo sh 14-loops.sh nginx mysql nodejs
do
    dnf list installed $package &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        echo "$package is not installed, Installing now" 
        dnf install $package -y &>>$LOGS_FILE
        #validate $? "$package installation"
    else
        echo "$package is already installed, Skipping installation"
    fi
done
