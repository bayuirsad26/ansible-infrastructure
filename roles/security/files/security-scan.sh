#!/bin/bash
# Security scanning script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
LOGFILE="/var/log/security-scan.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() {
    echo -e "${GREEN}[$TIMESTAMP] $1${NC}" | tee -a "$LOGFILE"
}

log_warn() {
    echo -e "${YELLOW}[$TIMESTAMP] WARNING: $1${NC}" | tee -a "$LOGFILE"
}

log_error() {
    echo -e "${RED}[$TIMESTAMP] ERROR: $1${NC}" | tee -a "$LOGFILE"
}

log "Starting security scan"

# Check for rootkits
if command -v rkhunter &> /dev/null; then
    log "Running rkhunter scan"
    rkhunter --update --quiet || true
    rkhunter --check --skip-keypress --quiet || log_warn "rkhunter found potential issues"
fi

# Check for unauthorized SUID files
log "Checking for unauthorized SUID files"
SUID_FILES=$(find /usr /bin /sbin -type f -perm -4000 2>/dev/null | wc -l)
log "Found $SUID_FILES SUID files"
if [ "$SUID_FILES" -gt 50 ]; then
    log_warn "High number of SUID files found"
fi

# Check file permissions
log "Checking critical file permissions"
PERM_ISSUES=0

for file in /etc/passwd /etc/shadow /etc/group /etc/sudoers; do
    if [ -f "$file" ]; then
        PERMS=$(stat -c %a "$file")
        case "$file" in
            "/etc/passwd") [ "$PERMS" != "644" ] && log_warn "Wrong permissions on $file: $PERMS" && PERM_ISSUES=$((PERM_ISSUES+1)) ;;
            "/etc/shadow") [ "$PERMS" != "600" ] && log_warn "Wrong permissions on $file: $PERMS" && PERM_ISSUES=$((PERM_ISSUES+1)) ;;
            "/etc/group") [ "$PERMS" != "644" ] && log_warn "Wrong permissions on $file: $PERMS" && PERM_ISSUES=$((PERM_ISSUES+1)) ;;
            "/etc/sudoers") [ "$PERMS" != "440" ] && log_warn "Wrong permissions on $file: $PERMS" && PERM_ISSUES=$((PERM_ISSUES+1)) ;;
        esac
    fi
done

# Check for world-writable files
log "Checking for world-writable files"
WORLD_WRITABLE=$(find /etc /bin /sbin /usr/bin /usr/sbin -type f -perm -002 2>/dev/null | wc -l)
if [ "$WORLD_WRITABLE" -gt 0 ]; then
    log_warn "Found $WORLD_WRITABLE world-writable files"
fi

# Check auditd status
log "Checking audit daemon status"
if systemctl is-active --quiet auditd; then
    log "Audit daemon is running"
else
    log_error "Audit daemon is not running"
fi

# Summary
log "Security scan completed"
log "Permission issues: $PERM_ISSUES"
log "World-writable files: $WORLD_WRITABLE"
log "SUID files: $SUID_FILES"

# Exit with error if issues found
if [ "$PERM_ISSUES" -gt 0 ] || [ "$WORLD_WRITABLE" -gt 0 ]; then
    exit 1
fi

exit 0
