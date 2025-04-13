#!/bin/bash

# Configuration
THRESHOLD=75
LOG_FILE="/var/log/disk_space_monitor.log"

# Header for log file
echo "=== Disk Space Check - $(date) ===" >> $LOG_FILE

# Check disk space
df -h | awk 'NR>1 {print $5 " " $6}' | while read output; do
    USAGE=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
    MOUNT=$(echo $output | awk '{print $2}')
    
    if [ $USAGE -ge $THRESHOLD ]; then
        echo "WARNING: $MOUNT is at ${USAGE}% usage" >> $LOG_FILE
    else
        echo "OK: $MOUNT is at ${USAGE}% usage" >> $LOG_FILE
    fi
done

echo "" >> $LOG_FILE