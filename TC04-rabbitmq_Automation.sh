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


modulevalidate(){
     mosulestatus=$1

     if [ "$modulestatus" - eq 0 ];
     then 
     echo ""$2" [INFO] module consists-----SUCCESS"   &>> "$logfullpath" 
     elif [ "$modulestatus" -ne 0 ];
     then 
     echo ""$2" skipping "    &>> "$logfullpath" 
     fi      

}

#rabbitmq
cp rabbitmq /etc/yum.repos.d/rabbitmq.repo
validate $? "repo has been added to the repo file"
dnf list erlang -y        &>> "$logfullpath"
modulevalidate $? "dnf list erlang"
dnf list rabbitmq-server -y &>> "$logfullpath"
modulevalidate $? "dnf list rabbitmq-server"
dnf module list erlang -y   &>> "$logfullpath"
modulevalidate $? "dnf module list erlang"

dnf module list rannitmq-server -y &>> "$logfullpath"

modulevalidate $? "dnf module list rannitmq-server"

dnf install erlang -y    &>> "$logfullpath"
validate $? "dnf install erlang"

dnf install rabbitmq-server -y     &>> "$logfullpath"
validate $? "dnf install rabbitmq-server -y"

systemctl enable rabbitmq-server     &>> "$logfullpath"
validate $? "systemctl enable rabbitmq-server"

systemtl start rabbitmq-server        &>> "$logfullpath"
validate $? "systemtl start rabbitmq-server"

systemtl status rabbitmq-server        &>> "$logfullpath"
validate $? "systemtl status rabbitmq-server"








