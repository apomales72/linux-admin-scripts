#!/bin/bash

# user_management.sh
# Simple user management toolkit for Linux systems
# Requires root privileges for adding/deleting users

# ===== Functions =====

add_user() {
    echo -n "Enter the username to add: "
    read USERNAME
    if id "$USERNAME" &>/dev/null; then
        echo "User '$USERNAME' already exists."
    else
        sudo useradd -m "$USERNAME"
        echo "User '$USERNAME' created."
        sudo passwd "$USERNAME"
    fi
}

delete_user() {
    echo -n "Enter the username to delete: "
    read USERNAME
    if id "$USERNAME" &>/dev/null; then
        sudo userdel -r "$USERNAME"
        echo "User '$USERNAME' deleted."
    else
        echo "User '$USERNAME' does not exist."
    fi
}

list_users() {
    echo "Listing system users:"
    cut -d: -f1 /etc/passwd
}

lock_user() {
    echo -n "Enter the username to lock: "
    read USERNAME
    if id "$USERNAME" &>/dev/null; then
        sudo passwd -l "$USERNAME"
        echo "User '$USERNAME' has been locked."
    else
        echo "User '$USERNAME' does not exist."
    fi
}

unlock_user() {
    echo -n "Enter the username to unlock: "
    read USERNAME
    if id "$USERNAME" &>/dev/null; then
        sudo passwd -u "$USERNAME"
        echo "User '$USERNAME' has been unlocked."
    else
        echo "User '$USERNAME' does not exist."
    fi
}

# ===== Menu =====
while true; do
    echo "============================"
    echo " User Management Menu"
    echo "============================"
    echo "1) Add new user"
    echo "2) Delete user"
    echo "3) List all users"
    echo "4) Lock user account"
    echo "5) Unlock user account"
    echo "6) Exit"
    echo -n "Select an option [1-6]: "
    read CHOICE
    
    case $CHOICE in
        1) add_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) lock_user ;;
        5) unlock_user ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Try again." ;;
    esac
    echo
done

