#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_USAGE=$(df -hT | grep -v Filesystem)
USAGE_THRESHOLD=3

echo "$DISK_USAGE"

while IFS= read -r line;
do
   USAGE=$(echo $DISK_USAGE | awk '{print $6}')
   echo "$USAGE"  

done <<< $DISK_USAGE