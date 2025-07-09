#!/bin/bash
# Simplified log cleanup script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
RETENTION_DAYS="${1:-30}"
LOG_DIRS="/var/log"
LOGFILE="/var/log/log-cleanup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create log directory
mkdir -p "$(dirname "$LOGFILE")"

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOGFILE"
}

log "Starting log cleanup (retention: ${RETENTION_DAYS} days)"

# Cleanup rotated log files
log "Cleaning up rotated log files..."
CLEANED_FILES=$(find $LOG_DIRS -name "*.log.*" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
log "Cleaned up $CLEANED_FILES rotated log files"

# Cleanup compressed logs
log "Cleaning up compressed logs..."
CLEANED_COMPRESSED=$(find $LOG_DIRS -name "*.gz" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
log "Cleaned up $CLEANED_COMPRESSED compressed log files"

# Cleanup old numbered logs
log "Cleaning up numbered logs..."
CLEANED_NUMBERED=$(find $LOG_DIRS -name "*.log.[0-9]*" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
log "Cleaned up $CLEANED_NUMBERED numbered log files"

# Check disk space
DISK_USAGE=$(df /var/log | awk 'NR==2 {print $5}' | sed 's/%//')
log "Current /var/log disk usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt 80 ]; then
    log "WARNING: Log disk usage is high (${DISK_USAGE}%)"
fi

log "Log cleanup completed successfully"
