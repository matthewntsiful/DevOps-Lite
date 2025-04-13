#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root. Use 'sudo ./setup_users.sh'." >&2
  exit 1
fi

# Create groups
addgroup --force-badname dev      # --force-badname allows lowercase group names
addgroup --force-badname web
addgroup --force-badname ops

# Create users with home directories, add to groups, and skip interactive prompts
adduser --disabled-password --gecos "" --ingroup dev devadmin
adduser --disabled-password --gecos "" --ingroup web webadmin
adduser --disabled-password --gecos "" --ingroup ops automation

# Add users to secondary groups (if needed)
adduser devadmin dev
adduser webadmin web
adduser automation ops

# Create shared directory for developers
mkdir -p /opt/dev
chown devadmin:dev /opt/dev
chmod 770 /opt/dev

# Set passwords (optional - better to do this interactively)
echo "devadmin:DevAdminPass123" | chpasswd
echo "webadmin:WebAdminPass123" | chpasswd
echo "automation:AutoPass123" | chpasswd

echo "User and group setup completed successfully."
