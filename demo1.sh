#!/bin/bash
PERSON1=$1
PERSON2=$2

echo "Script file name: $0"
echo "Number of args passed: $#"
echo "PWD: $PWD"
echo "Current User: $USER"
echo "Home directory of current user: $HOME"
echo "PID of the script: $$"


echo "$PERSON1:: Hello $PERSON2, How are you?"
echo "$PERSON2:: Hi $PERSON1, I am good. How about you?"
echo "$PERSON1:: I am doing great. What are you learning $PERSON2?"
echo "$PERSON2:: I am learning Shell Scripting. what about you?"

