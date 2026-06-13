# #!/bin/bash

# userid=$(id -u)
# logs_folder="/var/log/shell-script"
# log_file="$logs_folder/$0.log"
# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"

# if [ $userid -ne 0 ]; then
#   echo -e "$R Run with sudo access $N" | tee -a $log_file
#   exit 1
# fi

# mkdir -p $logs_folder

# validate() {
#    if [ $1 -ne 0 ]; then
#      echo -e "$R $2 is Failed ... $N" | tee -a $log_file
#      exit 1
#     else
#        echo -e "$G $2 is Success ... $N" | tee -a $log_file
#    fi
# }

# for package in $@
# do
#   dnf list installed $package &>> $log_file
#     if [ $? -ne 0 ]; then
#         echo -e "$Y $package is not installed $N, $G Installing now ... $N" | tee -a $log_file
#         dnf install $package -y &>> $log_file
#         validate $? "$package Installation"
#     else
#         echo -e "$package is already installed, $Y Skipping now ... $N" | tee -a $log_file
#     fi
# done



#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

logs_folder="/var/log/shell-script"
log_file="$logs_folder/$0.log"

if [ $userid -ne 0 ]; then
    echo -e "$R Please Run with sudo access $N" | tee -a $log_file
    exit 1
fi

mkdir -p $logs_folder


for package in $@
do
    if dnf list installed $package &>> $log_file; then
        echo "$package is already installed , Skiiping now ..." | tee -a $log_file
    else
        echo "$package is not installed, Installing now ..." | tee -a $log_file
        if dnf install $package -y &>> $log_file; then
             echo "$package Installation is success" | tee -a $log_file
        else
              echo "$package Installation is Failed" | tee -a $log_file
              exit 1
        fi
    fi
done