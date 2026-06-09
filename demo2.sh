#!/bin/bash

TIMESTAMP=$(date)
echo "$TIMESTAMP"

start=$(date +%H:%M)
echo "Script executed at: $start"
sleep 5
end=$(date +%H:%M)
echo "Script ended at: $end"

duration=$(($end - $start))

echo "Total duration: $duration"

