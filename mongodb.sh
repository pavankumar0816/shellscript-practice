#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $logs_folder

userid=$(id -u)


if [ $userid -ne 0 ]; then
    echo -e "$R Please run this script as root user $N" | tee -a $log_file
    exit 1
fi


validate() {
   if [ $1 -ne 0 ]; then
      echo -e "$R $2 is Failed, Please check the log file $N $log_file" | tee -a $log_file
      exit 1
    else
       echo -e "$2 is $G Success $N" | tee -a $log_file
   fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "Copying Mongo Repo"

dnf install mongodb-org -y &>>$log_file
validate $? "Installing MongoDb"

systemctl enable mongod &>>$log_file
validate $? "Enabling MongoDb"

systemctl start mongod 
validate $? "Start Mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf 
validate $? "Allowing Remote Connections"

systemctl restart mongod
validate $? "Restarting MongoDb"

