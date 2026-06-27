#!/bin/bash

#Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Getting disk usage, excluding header
DISK_USAGE=$(df -hT | grep -v Filesystem)

#For example i have taken 3
USAGE_THRESHOLD=85

# Loop through each disk entry 
while IFS= read -r line;
do
     # Extract disk usage percentage (remove % symbol)
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)

    # Extract mounted partition
    PARTITION=$(echo "$line" | awk '{print $7}')

    # Checking if usage exceeds the threshold
    if [ "$USAGE" -gt "$USAGE_THRESHOLD" ]; then
        MESSAGE+="$R High disk usage on   $N"$PARTITION": $R "$USAGE"% $N  \n"
    fi
done <<< "$DISK_USAGE"

echo -e "$MESSAGE"