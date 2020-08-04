#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Argument Error.  Please specify the Time interval in seconds."
    exit
fi

timeinterval=$1 # change this to the desired time interval
currenttime=$(cat /proc/uptime | cut -d'.' -f1);
echo $currenttime;
echo $timeinterval;
mintime=$(($currenttime-$timeinterval));
echo $mintime
dmesg | grep tty | while read line; do 
    #echo "$line"
    #dmesgstamp=$(echo "$line" | awk -F'[' '{print $0}' | awk -F\. '{print $1}')
    #dmesgstamp=$(echo "$line" | cut -d']' -f1)
    #echo "$dmesgstamp"
    #dmesgstampday=$(echo "$dmesgstamp" | cut -d' ' -f1 | cut -d'[' -f2)
    #dmesgstampmonth=$(echo "$dmesgstamp" | cut -d' ' -f2)
    #dmesgstampdayte=$(echo "$dmesgstamp" | cut -d' ' -f3)
    #dmesgstampdate=$(echo "$dmesgstamp" | cut -d' ' -f4)
    #dmesgstampyear=$(echo "$dmesgstamp" | cut -d' ' -f5)
    #echo "$dmesgstampday,$dmesgstampmonth,$dmesgstampdayte,$dmesgstampdate,$dmesgstampyear"
    #dmesgstamp=$((dmesgstamp += bootime))
    #results=$((currenttime-dmesgstamp))
    #echo "$results,$dmesgstamp"
    #if ((results < timeinterval)); then
    #    echo "$line"
    #fi
    #dmesgstamp=$(echo "$line" | awk -F'[' '{print $2}' | awk -F\. '{print $1}')
    #echo "$dmesgstamp"
    #dmesgstamp=$((dmesgstamp += bootime))
    #echo "$dmesgstamp"
    #results=$((currenttime-dmesgstamp))
    #echo "$results"
    dmesgstamp=$(echo "$line" | awk -F'[' '{print $2}' | awk -F\. '{print $1}')
    if (($dmesgstamp > $mintime)); then
        echo "$line"
    fi
done