#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-01cbaa06a27135f05"


for instance in $@
do
   instance_id=$(
    aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text 
    )

    if [ $instance == "frontend" ]; then
        IP=$(
        aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text
        )
    else
      IP=$(aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' \
        --output text
      )
    fi
    echo "Instance Id: $instance_id is created for $instance"
    echo "IP Address: $IP"
done    
