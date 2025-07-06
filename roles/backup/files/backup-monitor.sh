#!/bin/bash
# Backup monitoring script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
METRICS_FILE="/var/log/backup/metrics.log"
STATUS_FILE="/var/log/backup/status.json"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
EPOCH=$(date +%s)

# Create metrics directory
mkdir -p "$(dirname "$METRICS_FILE")"

# Check backup status
BACKUP_STATUS="unknown"
LAST_BACKUP=0

if [[ -f "/var/log/backup/system-backup.log" ]]; then
    if grep -q "System backup completed successfully" /var/log/backup/system-backup.log; then
        BACKUP_STATUS="success"
        LAST_BACKUP=$(stat -c %Y /var/log/backup/system-backup.log 2>/dev/null || echo 0)
    else
        BACKUP_STATUS="failed"
    fi
fi

# Calculate time since last backup
TIME_SINCE_BACKUP=$(( EPOCH - LAST_BACKUP ))
HOURS_SINCE_BACKUP=$(( TIME_SINCE_BACKUP / 3600 ))

# Write metrics (Prometheus format)
{
    echo "backup_last_success_timestamp $LAST_BACKUP"
    echo "backup_status{status=\"$BACKUP_STATUS\"} 1"
    echo "backup_hours_since_last $HOURS_SINCE_BACKUP"
    echo "backup_check_timestamp $EPOCH"
} >> "$METRICS_FILE"

# Write status JSON
cat > "$STATUS_FILE" << EOF
{
  "timestamp": "$TIMESTAMP",
  "epoch": $EPOCH,
  "backup_status": "$BACKUP_STATUS",
  "last_backup": $LAST_BACKUP,
  "hours_since_backup": $HOURS_SINCE_BACKUP,
  "healthy": $([ "$BACKUP_STATUS" = "success" ] && [ $HOURS_SINCE_BACKUP -lt 48 ] && echo "true" || echo "false")
}
EOF

# Alert if backup is too old
if [[ $HOURS_SINCE_BACKUP -gt 48 ]]; then
    logger -t backup-monitor "WARNING: Backup is ${HOURS_SINCE_BACKUP} hours old"
fi
