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

if command -v node &>/dev/null && node -v | grep -q "^v20"; then
    echo -e "NodeJs 20 is already Installed, ... $Y Skipping $N" | tee -a $log_file
else
    dnf module disable nodejs -y &>>$log_file
    validate $? "Disabling Nodejs default version"

    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "Enabling Nodejs version 20"

    dnf install nodejs -y &>>$log_file
    validate $? "Installing Nodejs"
fi

id roboshop &>>$log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    validate $? "Creating system user"
else
    echo -e "Roboshop User already created, ... $Y Skipping now .. $N" | tee -a $log_file
fi

mkdir -p /app 
validate $? "Creating App Directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>$log_file
validate $? "Downloading Cart App Content"

cd /app 
validate $? "Moving to App Directory"

rm -rf /app/*
validate $? "Removing Existing code"

unzip /tmp/cart.zip &>>$log_file
validate $? "Extracting app content"

npm install &>>$log_file
validate $? "Installing Nodejs Dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$log_file
validate $? "Creating Cart Service file"

systemctl daemon-reload
validate $? "Reloaded"

systemctl enable cart &>>$log_file
systemctl start cart
validate $? "Enabled and Started service file"

