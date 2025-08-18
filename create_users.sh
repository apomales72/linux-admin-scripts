#!/bin/bash

# Simple script to create multiple users in Red Hat Linux

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Prompt for number of users to create
read -p "How many users to create? " num_users

# Validate input is a number
if ! [[ "$num_users" =~ ^[0-9]+$ ]]; then
    echo "Please enter a valid number"
    exit 1
fi

# Loop to create users
for ((i=1; i<=num_users; i++)); do
    username="user$i"
    password="pass$i"
    
    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists, skipping..."
        continue
    fi
    
    # Create user with home directory and set password
    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd
    echo "Created user: $username with password: $password"
done

echo "User creation complete!"
