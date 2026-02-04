#!/bin/bash

timestamp=$(date "+%y-%m-%d %H:%M:%S")

echo "Script executed at $timestamp"
starttime=$(date +%s)
sleep 5
endtime=$(date +%s)
echo "Script Ended at $timestamp"
duration=$(($endtime-$starttime))
echo "Time taken : $duration"

