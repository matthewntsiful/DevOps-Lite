#!/bin/bash

# Check if Nginx is running
if systemctl is-active --quiet nginx; then
    echo "Nginx is running"
else
    echo "Nginx is NOT running"
    exit 1
fi

# Check Nginx status with more details
echo -e "\nNginx status:"
systemctl status nginx --no-pager | head -n 5

# Check listening ports
echo -e "\nNginx listening ports:"
ss -tulpn | grep nginx

# Check last 5 error log entries
echo -e "\nLast 5 error log entries:"
tail -n 5 /var/log/nginx/error.log