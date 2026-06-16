#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.pmpkdev.online
userid=$(id -u)
SCRIPT_DIR=$PWD

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
    echo "NodeJs 20 is already Installed, ... $Y Skipping $N" | tee -a $log_file
else
    dnf module disable nodejs -y
    validate $? "Disabling Nodejs default version"

    dnf module enable nodejs:20 -y
    validate $? "Enabling Nodejs version 20"

    dnf install nodejs -y
    validate $? "Installing Nodejs"
fi

id roboshop &>>$log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    validate $? "Creating system user"
else
    echo -e "Roboshop User already created, ... $Y Skipping now .. $N" | tee -a $log_file
fi

mkdir /app 
validate $? "Creating App Directory"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>$log_file
validate $? "Downloading user app content"

cd /app
validate $? "Moving to App Directory"

unzip /tmp/user.zip &>>$log_file
validate $? "Extracting App Content"

npm install &>>$log_file
validate $? "Installing Nodejs Dependencies"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service &>>$log_file
validate $? "Created Sysytemctl service file"

systemctl daemon-reload
validate $? "Reloaded"

systemctl enable user &>>$log_file
systemctl start user
validate $? "Enabled and started user service"