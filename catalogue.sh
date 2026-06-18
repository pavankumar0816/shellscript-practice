#!/bin/bash

logs_folder="/var/log/roboshop"
log_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
echo "Presnet Directory: $SCRIPT_DIR"
MONGODB_HOST=mongodb.pmpkdev.online
userid=$(id -u)

if [ $userid -ne 0 ]; then
  echo -e "$R Please run this script with sudo access $N" | tee -a $log_file
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
if command -v node &>/dev/null  && node -v | grep -q "^v20"; then
echo -e "Nodejs 20 version is already installed, $Y Skipping now $N" | tee -a $log_file
else
dnf module disable nodejs -y &>>$log_file
validate $? "Disabling Nodejs Default version"

dnf module enable nodejs:20 -y &>>$log_file
validate $? "Enabling Nodejs 20 version"

dnf install nodejs -y &>>$log_file
validate $? "Installing Nodejs"
fi

id roboshop &>>$log_file
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
    validate $? "Creating system user"
else
    echo -e "Roboshop user already exists, $Y Skipping... $N" | tee -a $log_file
fi

mkdir -p /app 
validate $? "Creating App Directory"


curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$log_file
validate $? "Downloading Catalogue app content"

cd /app 
validate $? "Moving to App Directory"

SCRIPT_DIR1=$PWD
echo -e "Presnet Directory:$G $SCRIPT_DIR1 $N"

rm -rf /app/*
validate $? "Removing "

unzip /tmp/catalogue.zip &>>$log_file
validate $? "Extracting App content"

npm install &>>$log_file
validate $? "Installing Nodejs Dependencies"

echo -e "Presnet Directory:$G $SCRIPT_DIR1 $N"
cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>>$log_file
validate $? "Creating Catalogue service file" 



systemctl daemon-reload
validate $? "Reloaded"

systemctl enable catalogue &>>$log_file
systemctl start catalogue
validate $? "Enabled and started catalogue service"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying mongo repo"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "Installing Mongodb client package"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")') # Mongodb shell command to check db exists or not db.getMongo().getDBNames() will list all the dbs and indexOf("catalogue") will check if catalogue db is there or not if it is there it will return index number 1 if not it will return -1

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    validate $? "Loading Products"
else
    echo -e "Products are already loaded ... $Y Skipping $N"  
fi

systemctl restart catalogue
validate $? "Restarting catalogue service"