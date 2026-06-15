#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"

instances=$(aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*]' \
  )

  echo "Running Instances: $instances"