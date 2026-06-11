#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]; then
   echo "You must run it as root user"
   exit 1 
fi

# remove()
# {
#    if [ $1 -ne 0]; then
#        echo "$2 is not available to remove"
#        exit 1
#    else
#         echo "$2 is removed Successfully"
#    fi
# }

# dnf remove nginx -y
# remove $? "Nginx"

# dnf remove mysql -y
# remove $? "Mysql"

# dnf remove mysqlll -y
# remove $? "Mysqlll"

validate(){
   if [ $1 -ne 0]; then 
      echo "$2 is Failed ...."
      exit 1
   else
       echo $2 is Success ...
   fi
}



dnf install mysqll -y
validate $? "Mysql installation"

dnf install  nginx -y
validate $? "Nginx Installation"
