#!/bin/bash

instancename=$1;

aws ec2 run-instances \
    --image-id ami-0055977a6e828a4f4 \
    --instance-type t3.micro \
    --security-group-ids sg-0728a52b520d47322  \
	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="${instancename}"}]"

echo "what is the exit code $? and the "${instancename}""