#!/bin/bash

items=("PC" "Mobile" "Tablet" "Desktop")
echo "Items: ${items[@]}"

for i in "${!items[@]}"
do 
echo "$i ${items[$i]}"
done

echo "Second Way"
count=0
for i in "${items[@]}"
do
   echo $count $i
   ((count++))
done