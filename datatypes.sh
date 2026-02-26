#!/bin/bash

items=("PC" "Mobile" "Tablet" "Desktop")
echo "Items: ${items[@]}"

for i in "${!items[@]}" #! means:Give me the INDEXES, not the values
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

a=1
b=2
c="pavan"

sum=$(($a + $b + $c))
echo "Sum: $sum"