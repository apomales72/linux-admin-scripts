#!/bin/bash
#=========================================================
# backup_and_restore.sh
# A simple script to backup and restore files or directories
# Author: Angel Pomales
# Date: 2025-08-09
#=========================================================

# Variables
BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Functions
usage() {
    echo "Usage:"
    echo "  $0 backup <source_path>"
    echo "  $0 restore <backup_file> <destination_path>"
    echo ""
    echo "Examples:"
    echo "  $0 backup /etc"
    echo "  $0 restore /var/backups/etc_20250809_101530.tar.gz /etc"
    exit 1
}

backup() {
    local source_path=$1

    if [ ! -d "$source_path" ] && [ ! -f "$source_path" ]; then
        echo "Error: Source path does not exist."
        exit 1
    fi

    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/$(basename "$source_path")_${TIMESTAMP}.tar.gz"

    tar -czf "$backup_file" -C "$(dirname "$source_path")" "$(basename "$source_path")"
    if [ $? -eq 0 ]; then
        echo "✅ Backup successful: $backup_file"
    else
        echo "❌ Backup failed."
        exit 1
    fi
}

restore() {
    local backup_file=$1
    local destination_path=$2

    if [ ! -f "$backup_file" ]; then
        echo "Error: Backup file does not exist."
        exit 1
    fi

    mkdir -p "$destination_path"
    tar -xzf "$backup_file" -C "$destination_path" --strip-components=1
    if [ $? -eq 0 ]; then
        echo "✅ Restore successful to: $destination_path"
    else
        echo "❌ Restore failed."
        exit 1
    fi
}

# Main Script
if [ $# -lt 2 ]; then
    usage
fi

case $1 in
    backup)
        backup "$2"
        ;;
    restore)
        if [ $# -ne 3 ]; then
            usage
        fi
        restore "$2" "$3"
        ;;
    *)
        usage
        ;;
esac

