#!/bin/bash
# backup_and_restore.sh
# A simple backup and restore utility for Linux systems.
# Author: Angel Pomales
# Date: 2025-08-09

# ===== Configuration =====
BACKUP_DIR="$HOME/backups"
RESTORE_DIR="$HOME/restore"
TIMESTAMP=$(date +%F_%H-%M-%S)

# ===== Functions =====
backup_files() {
    read -p "Enter the directory to back up: " SRC_DIR
    if [ ! -d "$SRC_DIR" ]; then
        echo "Error: Source directory does not exist."
        exit 1
    fi

    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$SRC_DIR" .
    echo "Backup completed: $BACKUP_FILE"
}

restore_files() {
    read -p "Enter the backup file to restore: " BACKUP_FILE
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "Error: Backup file not found."
        exit 1
    fi

    mkdir -p "$RESTORE_DIR"
    tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"
    echo "Restore completed to: $RESTORE_DIR"
}

# ===== Menu =====
echo "=== Backup & Restore Utility ==="
echo "1) Backup files"
echo "2) Restore files"
read -p "Select an option [1-2]: " OPTION

case $OPTION in
    1) backup_files ;;
    2) restore_files ;;
    *) echo "Invalid option." ;;
esac
