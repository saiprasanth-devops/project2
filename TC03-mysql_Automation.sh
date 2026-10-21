#!/bin/bash

# check the user is sudo or not
# id -u
# create the log folder and the file name
# create the common method for validating for exit code
# create dnf install and post them to logs
# create the systemctl and post them to logs



user_id=$(id -u)
logfolder="/var/log/roboshop"
logfile=$0
mkdir -p "$logfolder"
logfullpath=""${logfolder}"/"${logfile}".log"
touch "$logfullpath"
echo "------------------starting the execution run-----------------------------"         &>> "$logfullpath"  
echo ""$logfolder""    &>> "$logfullpath" 
echo ""$logfile""    &>> "$logfullpath"
echo ""$logfullpath""  &>> "$logfullpath"
echo ""$logfullpath""  | tee -a  "$logfullpath"

validate(){

    status_check=$1
    if [ "$status_check" -eq 0 ];
    then 
    echo "$(date) [INFO] "${2}" --------- success : PASS "   &>> "$logfullpath" 
  
    else
    echo "$(date) [INFO] "${2}" --------- Failed : Failed "   &>> "$logfullpath" 
    fi
}


if [ "$user_id" -eq 0 ];
then
echo "user is sudo user"
validate $? "user is sudo user"      
else
echo "please proceed with sudo user"
exit 1
fi


dnf module enable mysql:8.4 -y   &>> "$logfullpath" 
validate $? "dnf module enable mysql:8.4 -y"
dnf install mysql-server -y          &>> "$logfullpath" 
systemctl enable mysqld    &>> "$logfullpath" 
validate $? "systemctl enable mysqld"
systemctl start mysqld    &>> "$logfullpath" 
validate $? "systemctl start mysqld"























