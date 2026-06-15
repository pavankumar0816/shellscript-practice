#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-01cbaa06a27135f05"
hosted_zone_id="Z00391083QXL8RYXR03CG"
DOMAIN_NAME="pmpkdev.online"


for instance in $@
do
   instance_id=$(
    aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --output text 
    )

    if [ $instance == "frontend" ]; then
        IP=$(
        aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text
        )
        RECORD_NAME="$DOMAIN_NAME"
    else
      IP=$(aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' \
        --output text
      )
      RECORD_NAME="$instance.$DOMAIN_NAME"
    fi
    echo "Instance Id: $instance_id is created for $instance"
    echo "IP Address: $IP"


    aws route53 change-resource-record-sets \
    --hosted-zone-id $hosted_zone_id \
    --change-batch  '
        {
            "Comment": "Updating record",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$RECORD_NAME'",
                        "Type": "A",
                        "TTL": 1,
                        "ResourceRecords": [
                        {
                            "Value": "'$IP'"
                        }
                        ]
                    }
                }
            ]
        }
        '
done    
