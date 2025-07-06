#!/bin/bash
# Backup verification script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
LOG_FILE="/var/log/backup/verify.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$TIMESTAMP] ERROR: $1" | tee -a "$LOG_FILE" >&2
}

log "Starting backup verification"

# Check if restic is available
if ! command -v restic &> /dev/null; then
    log_error "Restic not found"
    exit 1
fi

# Load environment
if [[ -f "/etc/backup/credentials" ]]; then
    # shellcheck source=/etc/backup/credentials
    source /etc/backup/credentials
else
    log_error "Backup credentials not found"
    exit 1
fi

# Check repository connectivity
log "Checking repository connectivity"
if restic snapshots --latest 1 &> /dev/null; then
    log "✓ Repository is accessible"
else
    log_error "✗ Cannot access backup repository"
    exit 1
fi

# Verify latest backups exist
log "Checking recent backup snapshots"
LATEST_SYSTEM=$(restic snapshots --tag system --latest 1 --json 2>/dev/null | jq -r '.[0].time // empty')
LATEST_DOCKER=$(restic snapshots --tag docker-volume --latest 1 --json 2>/dev/null | jq -r '.[0].time // empty')

if [[ -n "$LATEST_SYSTEM" ]]; then
    SYSTEM_AGE=$(( $(date +%s) - $(date -d "$LATEST_SYSTEM" +%s) ))
    SYSTEM_AGE_HOURS=$(( SYSTEM_AGE / 3600 ))
    
    if [[ $SYSTEM_AGE_HOURS -lt 48 ]]; then
        log "✓ System backup is recent (${SYSTEM_AGE_HOURS}h ago)"
    else
        log_error "✗ System backup is old (${SYSTEM_AGE_HOURS}h ago)"
    fi
else
    log_error "✗ No system backups found"
fi

if [[ -n "$LATEST_DOCKER" ]]; then
    DOCKER_AGE=$(( $(date +%s) - $(date -d "$LATEST_DOCKER" +%s) ))
    DOCKER_AGE_HOURS=$(( DOCKER_AGE / 3600 ))
    
    if [[ $DOCKER_AGE_HOURS -lt 48 ]]; then
        log "✓ Docker backup is recent (${DOCKER_AGE_HOURS}h ago)"
    else
        log_error "✗ Docker backup is old (${DOCKER_AGE_HOURS}h ago)"
    fi
else
    log "⚠ No Docker backups found (may be expected)"
fi

# Verify repository integrity
log "Verifying repository integrity"
if restic check --read-data-subset=1% &> /dev/null; then
    log "✓ Repository integrity verified"
else
    log_error "✗ Repository integrity check failed"
    exit 1
fi

# Check storage usage
REPO_SIZE=$(restic stats --mode raw-data --json 2>/dev/null | jq -r '.total_size // 0')
REPO_SIZE_GB=$(( REPO_SIZE / 1024 / 1024 / 1024 ))
log "Repository size: ${REPO_SIZE_GB}GB"

log "Backup verification completed successfully"
