#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_USAGE=$(df -hT | grep -v Filesystem)
USAGE_THRESHOLD=3
 
# echo "$DISK_USAGE"

while IFS= read -r USAGE PARTITION <<< $(echo "$line" | awk '{print $6, $7}'
do
#    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
#    echo "$USAGE" 
#    PARTITION=$(echo "$line" | awk '{print $7}')

    if [ "$USAGE" -gt "$USAGE_THRESHOLD" ]; then
        MESSAGE+="High disk usage on "$PARTITION":"$USAGE"% \n"
    fi
done <<< "$DISK_USAGE"

echo -e "$MESSAGE"