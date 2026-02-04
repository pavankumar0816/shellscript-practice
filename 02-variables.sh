#!/bin/bash

timestamp=$(date)

echo "Script executed at $timestamp"
starttime=$(date +%s)
sleep 5
endtime=$(date +%s)
duration=$(($endtime-$starttime))
echo "Time taken : $duration"

