#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')   # b - batch mode (print to terminal, not interactive); n1 - show 1 iteration and exit (no refreshing); $2 - for user cpu; $4 - for system cpu

echo "System Monitoring Report - $(date)"
echo "-----------------------------------------"
echo "CPU Usage: $CPU%"
echo "Memory Usage: $MEMORY%"
echo "Disk Usage: $DISK"
echo "Uptime: $UPTIME"
echo ""
echo "Top 5 Processes by CPU Usage"
echo "$TOP_PROCESSES"
echo "-----------------------------------------"