#!/bin/bash
# System backup script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup/system-backup.log"
RETENTION_DAYS="7"

# Create directories
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$BACKUP_DIR/system"

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

log "Starting system backup"

# Create backup directory for this run
BACKUP_PATH="$BACKUP_DIR/system/$TIMESTAMP"
mkdir -p "$BACKUP_PATH"

# System paths to backup
SYSTEM_PATHS=("/etc" "/home" "/var/log" "/root")

# Backup system paths
for path in "${SYSTEM_PATHS[@]}"; do
    if [ -d "$path" ]; then
        log "Backing up $path"
        rsync -az "$path/" "$BACKUP_PATH/$(basename "$path")/"
    fi
done

# Create backup manifest
echo "Backup created: $TIMESTAMP" > "$BACKUP_PATH/backup-manifest.txt"
echo "Hostname: $(hostname)" >> "$BACKUP_PATH/backup-manifest.txt"
echo "Paths backed up:" >> "$BACKUP_PATH/backup-manifest.txt"
for path in "${SYSTEM_PATHS[@]}"; do
    if [ -d "$path" ]; then
        echo "  - $path" >> "$BACKUP_PATH/backup-manifest.txt"
    fi
done

# Cleanup old backups
log "Cleaning up old backups (retention: $RETENTION_DAYS days)"
find "$BACKUP_DIR/system" -type d -name "202*" -mtime +"$RETENTION_DAYS" -exec rm -rf {} \; 2>/dev/null || true

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
log "System backup completed: $BACKUP_PATH ($BACKUP_SIZE)"
