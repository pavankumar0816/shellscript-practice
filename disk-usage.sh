#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_USAGE=$(df -hT | grep -v Filesystem)
USAGE_THRESHOLD=3
MESSAGE=""

echo "$DISK_USAGE"

while IFS= read -r line;
do
   USAGE=$(echo $line | awk '{print $6}' | cut -d "%" -f1)
#    echo "$USAGE" 
   PARTITION=$(echo $line | awk '{print $7}')

    if [ $USAGE -gt $USAGE_THRESHOLD ]; then
        MESSAGE+="High disk usage on $PARTITION:$USAGE% <br>"
    fi
done <<< $DISK_USAGE

echo $MESSAGE