#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_DIR="/home/ec2-user/app-logs"
LOGS_FILE="$LOGS_DIR/$0.log"


if [ ! -d $LOGS_DIR ]; then
   echo -e "$R $LOGS_DIR does not exists $N ";
fi

FILES_TO_DELETE=$(find $LOGS_DIR -name "*.log" -mtime +14)
echo "$FILES_TO_DELETE"


