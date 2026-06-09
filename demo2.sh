#!/bin/bash

echo "All args passed to script: $@"
echo "Number of args passed: $#"
echo "Script name: $0"
echo "First arg: $1"
echo "Third arg: $3"
echo "All args as a single string: $*"
echo "Present working directory: $PWD"
echo "Current user: $USER"
echo "Home directory of current user: $HOME"
echo "PID: $$"
sleep 5 &
echo "PId of recently executed background process: $!"
echo "Exist status of last executed command: $?"



