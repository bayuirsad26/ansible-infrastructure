#!/bin/bash
# Log cleanup script for automated log maintenance
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
RETENTION_DAYS="${1:-30}"
LOG_DIRS="/var/log"
LOGFILE="/var/log/log-cleanup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOGFILE"
}

log "Starting log cleanup (retention: ${RETENTION_DAYS} days)"

# Cleanup old log files
log "Cleaning up old log files..."
CLEANED_FILES=$(find $LOG_DIRS -name "*.log.*" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
log "Cleaned up $CLEANED_FILES old log files"

# Cleanup old compressed logs
log "Cleaning up old compressed logs..."
CLEANED_COMPRESSED=$(find $LOG_DIRS -name "*.gz" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
log "Cleaned up $CLEANED_COMPRESSED compressed log files"

# Cleanup empty directories
log "Cleaning up empty log directories..."
find $LOG_DIRS -type d -empty -delete 2>/dev/null || true

# Check disk space
DISK_USAGE=$(df /var/log | awk 'NR==2 {print $5}' | sed 's/%//')
log "Current /var/log disk usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt 80 ]; then
    log "WARNING: Log disk usage is high (${DISK_USAGE}%)"
fi

# Cleanup Vector logs if present
if [ -d "/var/log/vector" ]; then
    VECTOR_CLEANED=$(find /var/log/vector -name "*.log" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
    log "Cleaned up $VECTOR_CLEANED Vector log files"
fi

# Cleanup Fluent Bit logs if present
if [ -d "/var/log/td-agent-bit" ]; then
    FLUENT_CLEANED=$(find /var/log/td-agent-bit -name "*.log" -type f -mtime +"$RETENTION_DAYS" -delete -print | wc -l)
    log "Cleaned up $FLUENT_CLEANED Fluent Bit log files"
fi

log "Log cleanup completed successfully"
