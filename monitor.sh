#!/bin/bash

LOGFILE="/var/log/sys_monitor.log"

echo "===== System Monitoring Report - $(date) =====" >> $LOGFILE

# CPU Usage
echo "       CPU Usage      " >> $LOGFILE
top -bn1 | grep "Cpu(s)" >> $LOGFILE
echo "" >> $LOGFILE

# RAM Usage
echo "      RAM Usage       " >> $LOGFILE
free -h >> $LOGFILE
echo "" >> $LOGFILE

# Disk Usage
echo "      Disk Usage    " >> $LOGFILE
df -h >> $LOGFILE                                                               
echo "" >> $LOGFILE

# Top 5 CPU consuming processes
echo "       Top 5 CPU Processes     " >> $LOGFILE
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> $LOGFILE
echo "" >> $LOGFILE

# Top 5 RAM consuming processes
echo "      Top 5 RAM Processes     " >> $LOGFILE
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 >> $LOGFILE
echo "====================================" >> $LOGFILE
echo "" >> $LOGFILE

echo "Report saved to $LOGFILE"