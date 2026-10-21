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
echo ""$logfolder""    &> "$logfullpath" 
echo ""$logfile""    &> "$logfullpath"
echo ""$logfullpath""  &> "$logfullpath"
echo ""$logfullpath""  | tee -a  "$logfullpath"







