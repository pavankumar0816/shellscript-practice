#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"

instances=$(aws ec2 describe-instances \
  --filters "Name=image-id,Values=ami-0220d79f3f480ecf5" \
  --query 'Reservations[*].Instances[*].InstanceId' \
  --output text)

  echo "Number of instances: $instances"