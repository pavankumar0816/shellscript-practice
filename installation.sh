#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $userid -ne 0 ]; then
    echo -e "$Y Run with sudo acess $N"
    exit 1
fi

echo "Installing Nginx web server..."
dnf install nginx -y

if [ $? -ne 0 ]; then
    echo -e "$R Failed $N"
    exit 1
else
    echo "Success"
fi