#!/bin/bash

userid=$(id -u)


if [ $userid -ne 0 ]; then
    echo "Run with root user access"
    exit 1
fi

echo "Installing nginx"
dnf install nginx -y

if[ $? -ne 0 ]; then
    echo "Installing nginx is failure";
    exit 1
else
    echo "Installed"
fi

dnf install mysql -y

if[ $? -ne 0 ]; then
    echo "Installing mysql is failure";
    exit 1
else
    echo "Installed"
fi