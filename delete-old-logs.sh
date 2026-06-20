#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_DIR=/home/ec2-user/app-logs
LOGS_FILE="$LOGS_DIR/$0.log"

if [ ! -d $LOGS_DIR ]; then
   echo -e "$LOGS_DIR $R Directory Not Exist $N" 
   exit 1
fi

FILES_TO_DELETE=$(find $LOGS_DIR -name "*.log" -mtime +14)
echo "$FILES_TO_DELETE"

while IFS= read -r filepath; 
do
   echo "$filepath"
done <<< $FILES_TO_DELETE
