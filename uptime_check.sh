#!/bin/bash

mkdir -p /var/log/uptime_check

while true; do
       UP=$(uptime)
       echo "$UP" >> /var/log/uptime_check/uptime.log

       LOAD=$(echo "$UP" | uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1) #-F separator and -d delimeter

       if awk "BEGIN {exit !($LOAD > 1)}"; then #because bash cannot compare float in -gt
               echo "$UP" >> /var/log/uptime_check/overload
       fi

       if [ -f /var/log/uptime_check/overload ]; then #-f if exists
               if [ $(stat -c%s "/var/log/uptime_check/overload") -ge 50000 ]; then
                       > /var/log/uptime_check/overload #cleaning
           date >> /var/log/uptime_check/cleanup   
       fi
   fi

   sleep 15
Done
