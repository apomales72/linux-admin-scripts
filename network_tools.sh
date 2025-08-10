#!/bin/bash

# network_tools.sh
# Simple menu-driven network diagnostics toolkit

# ===== Functions =====

check_connectivity() {
    echo "Enter host to ping (default: 8.8.8.8): "
    read HOST
    HOST=${HOST:-8.8.8.8}
    echo "Pinging $HOST..."
    ping -c 4 "$HOST"
}

check_ports() {
    echo "Enter host to scan (default: localhost): "
    read HOST
    HOST=${HOST:-localhost}
    echo "Enter port range to scan (default: 1-1024): "
    read PORTRANGE
    PORTRANGE=${PORTRANGE:-1-1024}
    
    if command -v nc &>/dev/null; then
        echo "Scanning $HOST ports $PORTRANGE..."
        nc -zv "$HOST" $(seq ${PORTRANGE/-/ })
    else
        echo "netcat (nc) not installed. Please install to use this feature."
    fi
}

check_bandwidth() {
    if command -v speedtest &>/dev/null; then
        echo "Running speed test..."
        speedtest
    else
        echo "Speedtest CLI not installed."
        echo "Install with: sudo apt install speedtest-cli"
    fi
}

get_ip_info() {
    echo "Local IP addresses:"
    ip addr show | grep 'inet ' | awk '{print $2}'
    echo
    echo "Public IP address:"
    curl -s ifconfig.me || echo "Unable to fetch public IP."
}

# ===== Menu =====
while true; do
    echo "============================"
    echo " Network Tools Menu"
    echo "============================"
    echo "1) Check connectivity (ping)"
    echo "2) Check open ports"
    echo "3) Check bandwidth speed"
    echo "4) Get IP address info"
    echo "5) Exit"
    echo -n "Select an option [1-5]: "
    read CHOICE
    
    case $CHOICE in
        1) check_connectivity ;;
        2) check_ports ;;
        3) check_bandwidth ;;
        4) get_ip_info ;;
        5) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Try again." ;;
    esac
    echo
done

