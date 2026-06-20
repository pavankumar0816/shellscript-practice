#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_DIR=/home/ec2-user/app-logs
LOGS_FILE="$LOGS_DIR/$0.log"
START_TIME=$(date +%s)

if [ ! -d $LOGS_DIR ]; then
   echo -e "$LOGS_DIR $R Directory Not Exist $N" 
   exit 1
fi

FILES_TO_DELETE=$(find $LOGS_DIR -name "*.log" -mtime +14)
# echo "$FILES_TO_DELETE"

while IFS= read -r filepath; 
do
   echo "Deleting File: $filepath" | tee -a $LOGS_FILE
   rm -f $filepath
   echo "Deleted Files: $filepath" | tee -a $LOGS_FILE
done <<< $FILES_TO_DELETE

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $START_TIME))
echo -e "$G Total time taken for deleting the logs: $Y $TOTAL_TIME $N"
