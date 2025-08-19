#!/bin/bash
LOGFILE="/var/log/sys-updates.log"
EMAIL="admin@example.com"

echo "Starting updates on $(date)" >> $LOGFILE
dnf update -y >> $LOGFILE 2>&1

tail -20 $LOGFILE | mail -s "System Update Report: $HOSTNAME" $EMAIL
