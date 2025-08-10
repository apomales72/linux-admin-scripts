#!/bin/bash

# monitor_disk_usage.sh
# A simple script to monitor disk usage and send alerts if usage exceeds a threshold.

# ===== Configurable Variables =====
THRESHOLD=80   # Percentage at which to trigger a warning
LOG_FILE="/var/log/disk_usage_monitor.log"
ALERT_EMAIL="admin@example.com"

# ===== Script Start =====
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Loop through each mounted filesystem (excluding tmpfs and overlay)
df -H --output=source,pcent,target | grep -vE 'tmpfs|overlay|Filesystem' | while read -r line
do
    FS=$(echo "$line" | awk '{print $1}')
    USAGE=$(echo "$line" | awk '{print $2}' | sed 's/%//')
    MOUNT_POINT=$(echo "$line" | awk '{print $3}')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        MESSAGE="WARNING: $FS mounted on $MOUNT_POINT is ${USAGE}% full."
        echo "$DATE - $MESSAGE" | tee -a "$LOG_FILE"

        # Optional email alert (requires mail command)
        if command -v mail &>/dev/null; then
            echo "$MESSAGE" | mail -s "Disk Usage Alert: $FS" "$ALERT_EMAIL"
        fi
    else
        echo "$DATE - OK: $FS mounted on $MOUNT_POINT is ${USAGE}% full." >> "$LOG_FILE"
    fi
done

