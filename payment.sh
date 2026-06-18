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
       echo -e " $2  is $R Failed, Please check the log file $N $log_file" | tee -a $log_file
      exit 1
    else
        echo -e "$2 is $G Success $N" | tee -a $log_file
    fi
}

dnf install python3 gcc python3-devel -y &>>$log_file
validate $? "Installing Python3 and build tools"

id roboshop &>>$log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    validate $? "Creating System User"
else
    echo -e "Roboshop user already exists, ... $Y SKipping ... $N" | tee -a $log_file
fi

mkdir /app 
validate $? "Creating Application Directory"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>>$log_file
validate $? "Downloading Payment App Content"

cd /app
validate $? "Moving to App Directory"

rm -rf /app/* 
validate $? "Removing Existing Code"

unzip /tmp/payment.zip &>>$log_file
validate $? "Extracting Payment App Content"

cd /app 
pip3 install -r requirements.txt &>>$log_file
validate $? "Installing Python Dependencies"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service &>>$log_file
validate $? "Copying Payment Service File"

systemctl daemon-reload
validate $? "Reloaded"

systemctl enable payment&>>$log_file
systemctl start payment
validate $? "Enable and Started Payment Service"
