#!/bin/bash
# Docker backup script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup/docker-backup.log"
RETENTION_DAYS="7"

# Create directories
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$BACKUP_DIR/docker"

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

log "Starting Docker backup"

# Check if Docker is running
if ! docker info &> /dev/null; then
    log "ERROR: Docker is not running"
    exit 1
fi

# Create backup directory for this run
BACKUP_PATH="$BACKUP_DIR/docker/$TIMESTAMP"
mkdir -p "$BACKUP_PATH"

# Backup Docker volumes
log "Backing up Docker volumes"
VOLUMES=$(docker volume ls -q)

if [ -n "$VOLUMES" ]; then
    for volume in $VOLUMES; do
        log "Backing up volume: $volume"
        
        # Create temporary container to access volume
        docker run --rm \
            -v "$volume":/volume:ro \
            -v "$BACKUP_PATH":/backup \
            alpine tar czf "/backup/$volume.tar.gz" -C /volume .
    done
else
    log "No Docker volumes found"
fi

# Create backup manifest
echo "Docker backup created: $TIMESTAMP" > "$BACKUP_PATH/docker-manifest.txt"
echo "Hostname: $(hostname)" >> "$BACKUP_PATH/docker-manifest.txt"
echo "Volumes backed up:" >> "$BACKUP_PATH/docker-manifest.txt"
if [ -n "$VOLUMES" ]; then
    for volume in $VOLUMES; do
        echo "  - $volume" >> "$BACKUP_PATH/docker-manifest.txt"
    done
else
    echo "  - None" >> "$BACKUP_PATH/docker-manifest.txt"
fi

# Cleanup old backups
log "Cleaning up old Docker backups (retention: $RETENTION_DAYS days)"
find "$BACKUP_DIR/docker" -type d -name "202*" -mtime +"$RETENTION_DAYS" -exec rm -rf {} \; 2>/dev/null || true

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
log "Docker backup completed: $BACKUP_PATH ($BACKUP_SIZE)"
