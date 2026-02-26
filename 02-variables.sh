#!/bin/bash

timestamp=$(date "+%y-%m-%d %H:%M:%S")
Timestamp=$(date)

echo "$Timestamp"

echo "Script executed at $timestamp"
starttime=$(date +%s)
sleep 5
endtime=$(date +%s)
echo "Script Ended at $endtime"
duration=$(($endtime-$starttime))
echo "Time taken : $duration"

