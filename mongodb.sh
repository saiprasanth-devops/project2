#!/bin/bash


foldername="/etc/yum.repos.d/"
filename="mongo.repo"
logsfolder="/home/ec2-user/cartservice2/project2/"
logfilename=$0
configadrchange="sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf"
configfile="/etc/mongod.conf"
appname="mongodb-org"


mkdir -p "$logsfolder"

timestamp=$(date +%F-%H-%M-%S)
logfilename="${logfilename}_${timestamp}.txt"

touch "${logsfolder}/${logfilename}"

logfilefullname=$(realpath "${logsfolder}/${logfilename}")

echo "$logfilefullname"
# ###########added the data
validate_status(){
statuscode=$(echo $?)
echo "$statuscode"
if [ "$statuscode" -eq 0 ];
then 
echo "status code is "${statuscode}" ....proceed"    
else
echo "status code is "${statuscode}"....exit"
exit 1
 fi
} >> "$logfilefullname"
validate_status
user_id=$(id -u)
if [ "$user_id" -eq 0 ];
then 
validate_status
else
echo "user "${user_id}" and please execute with root access"  >> "$logfilefullname"
fi
cd "${foldername}"  >> "$logfilefullname"
validate_status
touch "$filename"  >> "$logfilefullname"
validate_status
echo "$MONGO_SERVICEFILE" >> ""${foldername}""${filename}""
validate_status
# status=$(echo $?)  
# echo "$status"
change_address(){
if [ -f "$configfile" ];
then 
echo "$configadrchange"
"$configadrchange"
validate_status
else
echo ""$configfile" is not present in the location...hence exit"
exit 1
fi 
}

mongodb_setup(){
    packagename=$1
#dnf list installed "$packagename"
#validate_status

# dnf search "$packagename" | grep "No matches found."
dnf install "$packagename" -y  >> "$logfilefullname"

systemctl enable mongod   >> "$logfilefullname"
validate_status
systemctl start mongod    >> "$logfilefullname"
validate_status
systemctl status mongod    >> "$logfilefullname"
validate_status
change_address
validate_status
systemctl restart mongod  >> "$logfilefullname"
validate_status
netstat -lntp | grep 27017   >> "$logfilefullname"
validate_status  
}

checkversion(){
packagename=$1

mongod --version
versionstatuscode=$(echo $?)     
if [ "$versionstatuscode" -ne 0 ];
then
echo ""$packagename" is not installed so proceed"   >> "$logfilefullname"
else
echo ""$packagename" is  installed so please exit"   >> "$logfilefullname"
exit 1
fi
}

#for app in "${APPNAME[@]}"
for app in "$appname"
do
echo "$app"
# packagename=$("echo $app")
packagename=$app
echo ""$packagename""

validate_status
if [ "$packagename" = "mongodb-org" ];
then
checkversion "$packagename"   >> "$logfilefullname"
mongodb_setup "$packagename"   >> "$logfilefullname"
# elif [ "$packagename" = "redis:7" ]
# do
# redis
# else 
else
echo ""$packagename" is not equal to the given list we need to install"  >> "$logfilefullname"
exit 1
fi
done



