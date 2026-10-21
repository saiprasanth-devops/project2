#!/bin/bash


#!/bin/bash

domain_name="godeploy.online"
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
     modulestatus=$1

     if [ "$modulestatus" -eq 0 ];
     then 
     echo ""$2" [INFO] module consists-----SUCCESS"   &>> "$logfullpath" 
     elif [ "$modulestatus" -ne 0 ];
     then 
     echo ""$2" skipping "    &>> "$logfullpath" 
     fi      

}

dnf list nodejs -y    &>> "$logfullpath" 
modulevalidate $? "dnf list nodejs -y"

dnf list available nodejs -y     &>> "$logfullpath" 
modulevalidate $? "dnf list available nodejs -y"

modulelist=$(dnf module list nodejs -y)     &>> "$logfullpath" 
echo ""$modulelist" check we have 24 version"    &>> "$logfullpath" 
modulevalidate $? "dnf module list nodejs -y"
 
dnf module disable nodejs -y                &>> "$logfullpath" 
modulevalidate $? "dnf module disable nodejs -y"

dnf module enable nodejs:24 -y              &>> "$logfullpath" 
modulevalidate $? "dnf module enable nodejs:24 -y"

dnf install nodejs -y              &>> "$logfullpath" 
validate $? "dnf install nodejs -y"

roboshopid=$(id roboshop)
if [ "$?" -eq 0 ];
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop    &>> "$logfullpath" 
else
echo "user is already present and skipping him to create"
fi
#validate $? "system user has been created"

mkdir -p /app
validate $? "create the app folder in the /"

curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/catalogue-v4.zip
validate $? "download the folder into the /tmp folder"

cd /app       &>> "$logfullpath" 
validate $? "go to app folder"
unzip /app/catalogue.zip
validate $? "and unzip it"

npm install               &>> "$logfullpath" 
validate $? "npm should be installed"

package=$(ls -l)
echo "$package"        &>> "$logfullpath" 

if [[ "$package" == *"package.json"* ]];
then
echo "we have the dependecies json"
else
echo "doesnot have the depenedency json"
exit 1
fi

cd /home/ec2-user/cartservice2/project2
cp catalogueservicefile /etc/systemd/system/catalogue.service            &>> "$logfullpath" 
validate $? "npm should be installed"              &>> "$logfullpath"

systemctl status catalogue  | tee -a "$logfullpath" 























