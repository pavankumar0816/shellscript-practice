#!/bin/bash

userid=$(id -u)

# Log Details
LOGS_FOLDER="/var/log/shellscript"
SCRIPT_NAME=$(basename "$0" .sh)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

# Color codes
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Arguments passed while executing the script
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # (optional) Default days is 14 days if not provided

# Validation function
log(){
    echo -e "$(date "+%Y-%m-%d ::: %H:%M:%S") |  $1" | tee -a $LOG_FILE
}

# Root user validation
if [ $userid -ne 0 ]; then
    log "$R Please run this script with root user access $N" 
    exit 1
fi

# Create logs directory if it doesn't exist
mkdir -p $LOGS_FOLDER

# Usage information
USAGE(){
    log "$R USAGE: sudo backup <source-dir> <dest-dir> <days>[default 14 days] $N"
    exit 1
}

# Validate input arguments
if [ $# -lt 2 ]; then
    USAGE
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log "$Y Source Directory: $SOURCE_DIR doest not exist $N"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    log "$Y DESTINATION DIRECTORY: $DEST_DIR doest not exist $N"
    exit 1
fi


## Find old log files
FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

if [ -z "$FILES" ]; then
    log "No files to Archive, $Y Skipping $N" 
else
    log "Files found to Archive: $FILES" 

    TIMESTAMP=$(date +%F-%H-%M-%S)
    ZIP_FILE=$DEST_DIR/app-logs-"$TIMESTAMP".tar.gz

    log "Archive name: $ZIP_FILE"

    # Create the archive
    tar -zcvf "$ZIP_FILE" $FILES

    if [ -f "$ZIP_FILE" ]; then
       log "Archieval is $G ... Success ...$N"

       
        # Delete archived log files
        while IFS= read -r filepath; do
        log "Deleting File: $filepath"
        rm -f $filepath
        log "Deleted File: $filepath"
        done <<< $FILES
    else
        log "Archieval is  $R ... Failure ... $N"
        exit 1
    fi
fi
