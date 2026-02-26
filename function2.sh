#!/bin/bash

userid=$(id -u)
echo "userid: $userid"

if [ $userid -ne 0 ]; then
echo "Run with root user access"
fi