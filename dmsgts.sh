#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Argument Error.  Please specify the Time interval in seconds."
    exit
fi

timeinterval=$1 # change this to the desired time interval
currenttime=$(cat /proc/uptime | cut -d'.' -f1);
#echo $currenttime;
#echo $timeinterval;
mintime=$(($currenttime-$timeinterval));
#echo $mintime
dmesg | grep tty | while read line; do 
    dmesgstamp=$(echo "$line" | awk -F'[' '{print $2}' | awk -F\. '{print $1}')
    if (($dmesgstamp > $mintime)); then
        echo "$line"
    fi
done