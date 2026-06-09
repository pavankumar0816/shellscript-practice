#!/bin/bash

TIMESTAMP=$(date)
echo "$TIMESTAMP"

start=$(date +%s)
echo "Script executed at: $start"
sleep 5
end=$(date +%s)
echo "Script ended at: $end"

duration=$(($end - $start))

echo "Total duration: $duration"

