#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_DIR=/home/ec2-user/app-logs
LOGS_FILE="$LOGS_DIR/$0.log"
START_TIME=$(date +%s)

if [ ! -d "$LOGS_DIR" ]; then
   echo -e "$LOGS_DIR $R Directory Not Exist $N" 
   exit 1
fi

FILES_TO_DELETE=$(find $LOGS_DIR -name "*.log" -mtime +14)
# echo "$FILES_TO_DELETE"

if [ -z "$FILES_TO_DELETE" ]; then
   echo "No old logs to delete"
   exit 0
fi

while IFS= read -r filepath; 
do
   echo "Deleting File: $filepath" | tee -a $LOGS_FILE
   rm -f "$filepath"
   echo "Deleted Files: $filepath" | tee -a $LOGS_FILE
done <<< $FILES_TO_DELETE

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $START_TIME))
echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Time take for deleting logs : $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
