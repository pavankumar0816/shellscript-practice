#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#userid
userid=$(id -u)

# Log Configuration
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

# Directory to Clean
SOURCE_DIR="/home/ec2-user/app-logs"  

# Create logs folder if not exists
mkdir -p "$LOGS_FOLDER"

# check root access
if [ $userid -ne 0 ]; then
   echo -e "$R Error: Please Run this script with root access $N" | tee -a "$LOGS_FILE"
   exit 1
fi

#checking source directory exists or not
if [ ! -d $SOURCE_DIR ]; then
    echo -e "Source Directory not exists, $Y Creating $N" | tee -a "$LOGS_FILE"
    mkdir -p $SOURCE_DIR
fi


# Function to validate command success
validate(){
    if [ $1 -ne 0 ]; then
        echo -e " $2  is $R Failed, Please check the log file $N "$LOGS_FILE"" | tee -a "$LOGS_FILE"
        exit 1
    else 
        echo -e "$2 is $G Success $N" | tee -a "$LOGS_FILE"
    fi
}

# Start of script execution
echo "Script started executing at $(date)" | tee -a "$LOGS_FILE"

# Find files older than 14 days
FILES_TO_DELETE=$(find "$SOURCE_DIR" -name "*.log" -mtime +14)

if [ -z "$FILES_TO_DELETE" ]; then
    echo -e "$Y No old logs to delete $N" | tee -a "$LOGS_FILE"
    exit 0
fi

#Delete each file found
while IFS= read -r filepath; 
do
        echo "Deleting File: $filepath"
        rm -rf "$filepath"
        echo "Deleted Files: $filepath" | tee -a "$LOGS_FILE"
done <<< "$FILES_TO_DELETE"

# End of script execution
echo "Script executed successfully at $(date)" | tee -a "$LOGS_FILE"