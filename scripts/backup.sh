#!/bin/bash

# Backup configuration
BACKUP_DIR="/backups"
SOURCE_DIR="/var/www"
MAX_BACKUPS=30  # Keep last 30 backups
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="www_backup_${DATE}.tar.gz"
LOG_FILE="/var/log/backup.log"

# Create backup directory if not exists
mkdir -p "${BACKUP_DIR}" || {
    echo "ERROR: Failed to create backup directory ${BACKUP_DIR}" | tee -a "${LOG_FILE}"
    exit 1
}

# Verify source directory exists
if [ ! -d "${SOURCE_DIR}" ]; then
    echo "ERROR: Source directory ${SOURCE_DIR} does not exist" | tee -a "${LOG_FILE}"
    exit 1
fi

# Create backup
echo "Starting backup of ${SOURCE_DIR} at ${DATE}" >> "${LOG_FILE}"
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" -C "${SOURCE_DIR}" . 2>> "${LOG_FILE}"

# Check if backup succeeded
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: ${BACKUP_NAME}" >> "${LOG_FILE}"
    
    # Rotate old backups
    cd "${BACKUP_DIR}" || exit
    ls -t | grep 'www_backup_' | tail -n +$((MAX_BACKUPS + 1)) | xargs rm -f --
    echo "Rotated backups, keeping latest ${MAX_BACKUPS}" >> "${LOG_FILE}"
else
    echo "ERROR: Backup failed for ${SOURCE_DIR}" | tee -a "${LOG_FILE}"
    exit 1
fi