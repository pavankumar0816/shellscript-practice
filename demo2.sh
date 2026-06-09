#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo "You must run it as root user"
   exit 1 
fi

echo "Installing nginx"
dnf install nginx -y

if [ $? -ne 0 ]; then
   echo "Failed to install Nginx"
   exit 1
else 
    echo "Installed nginx successfully"
fi


