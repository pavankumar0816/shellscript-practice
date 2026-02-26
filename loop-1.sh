#!/bin/bash

userid=$(id -u)
LOGS_FOLDER="/var/log/shellscript"
LOGS_FILE="$LOGS_FOLDER/$0.log"

if [ $userid -ne 0 ]; then
   echo "Run with sudo access" | tee -a $LOGS_FILE
   exit 1
fi

validate(){
  if [ $1 -ne 0 ]; then
    echo "$2 ... Failed" | tee -a $LOGS_FILE
    exit 1
  else
    echo "$2 ... Success" | tee -a $LOGS_FILE
fi
}

for packages in $@
do
  dnf list installed $packages &>> $LOGS_FILES
  if [ $? -ne 0 ]; then
    echo "$packages is not installed, Installing now..."
    dnf install $packages -y &>> $LOGS_FILE
    
  else
    echo "$packages is already installed"
  fi
done

