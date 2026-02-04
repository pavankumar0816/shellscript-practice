#!/bin/bash
username=$1
password=$2

echo "Enter ur name:"
read $username

echo "Your name is $username"
echo "Enter ur password:"
read -s $password
echo "Your password is $password"
