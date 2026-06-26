#!/bin/bash

userid=$(id -u)

LOGS_FOLDER="/var/log/shellscript"
SCRIPT_NAME=$(basename "$0" .sh)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

log(){
    echo -e "$(date "+%Y-%m-%d ::: %H:%M:%S") |  $1" | tee -a $LOG_FILE
}

if [ $userid -ne 0 ]; then
    log "$R Please run this script with root user access $N" 
    exit 1
fi

mkdir -p $LOGS_FOLDER

USAGE(){
    log "$R USAGE: sudo backup <source-dir> <dest-dir> <days>[default 14 days] $N"
    exit 1
}

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

log "Backup Started"
log "Source Directory: $SOURCE_DIR"
log "Destination Directory: $DEST_DIR"
log "Days: $DAYS"

## Find the files
FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

if [ -z "$FILES" ]; then
    log "No files to Archive, $Y Skipping $N" 
else
    log "Files found to Archive: $FILES" \
    TIMESTAMP=$(date)
    echo $TIMESTAMP
    ZIP_FILE=$DEST_DIR/app-logs-"$TIMESTAMP".tar.gz
    log "Archive name: $ZIP_FILE"
    # tar -zcvf "$ZIP_FILE" $FILES

fi


