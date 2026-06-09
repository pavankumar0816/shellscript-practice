#!/bin/bash

TIMESTAMP=$(date)
echo "$TIMESTAMP"

start=$(date +%S)
echo "Script executed at: $start"
sleep 5
end=$(date +%S)
echo "Script ended at: $end"

duration=$(($end - $start))

echo "Total duration: $duration"

