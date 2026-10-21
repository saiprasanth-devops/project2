#!/bin/bash

ami_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
domain_name="sandeep linux22.store"
hosted_zone_id="Z09842261W8MW372F9VFX"
#groups=("roboshop-common" "roboshop-redis")

for instance in $@
do
    echo "creating instance: ${instance}"

    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --security-groups "roboshop-common" "roboshop-redis"\
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-"${instance}"}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )

    echo "$?"

    echo "$instance ID: "$instance_id""
done


       # --security-groups "roboshop-common" "roboshop-"${instance}"" \


# for instance in $@
# do
# echo "passed values are "${instance}""
# instance_id=$(aws ec2 run-instances \
#     --image-id "$image_id" \
#     --instance-type "$instance_type" \
#     --security-group-ids "$security_group_ids"  \
# 	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="${instance}"}]" \
#     --query 'Instances[0].InstanceId' \
#     --output text)