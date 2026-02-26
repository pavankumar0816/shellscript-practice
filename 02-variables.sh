#!/bin/bash

timestamp=$(date "+%y-%m-%d %H:%M:%S")
Timestamp=$(date)

echo "$Timestamp"

echo "Script executed at $timestamp"
starttime=$(date +%s)
echo "Start Time: $starttime"
sleep 5
endtime=$(date +%s) # %s ==> It returns the number of seconds, unix timestamp
echo "Script Ended at $endtime"
duration=$(($endtime-$starttime))
echo "Time taken : $duration"

