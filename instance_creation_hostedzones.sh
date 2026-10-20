#!/bin/bash



image_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
security_group_ids="sg-02a3f89bd2dcb78b1"
#instance_name="general"
hosted_zone_id="Z063293532TA5U290WZK9"
record_name="godeploy.online"


for instance in $@
do
echo "passed values are "${instance}""
instance_id=$(aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --security-group-ids "$security_group_ids"  \
	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="${instance}"}]" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)



 echo "exit for the above statement $?"

if [ "$?" -eq 0 ];
then 
 if [ "$instance_id" = "frontend" ]; 
 then 
IP=$(aws ec2 describe-instances  \
--instance-ids "${instance_id}" \
--query 'Reservations[*].Instances[*].PublicIpAddress'  \
--output text)

route53="${instance}"."${record_name}"

else
IP=$(aws ec2 describe-instances  \
--instance-ids "${instance_id}" \
--query 'Reservations[*].Instances[*].PrivateIpAddress'  \
--output text)
route53="${record_name}"

fi
fi

aws route53 change-resource-record-sets \
  --hosted-zone-id "${hosted_zone_id}" \
  --change-batch '{
    "Comment": "'"$COMMENT"'",
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
               "Name": "'$route53'",
          "Type": "'"A"'",
          "TTL": '1',
          "ResourceRecords": [
            {
                 "ResourceRecords": [{"Value": "'$IP'"}]
            }
          ]
        }
      }
    ]
  }'


echo "instance name : "${instance}" and ip address of it : "${IP}""
done





