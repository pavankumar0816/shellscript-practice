#!/bin/bash

# NAME="Pavan"

# demo(){
#     echo "Learning Shell"
# }
# demo
#set      # ==> Displaying variables and functions 



set -u # handling undefined variables

NAME=$1
Course="Shell"
echo $NAME
# echo $course
echo $Course

#Managing Positional Parameters using set
set -- apple mango orange

echo "First Fruit: $1"
echo "Second Fruit: $2"
echo "Third Fruit: $3"
