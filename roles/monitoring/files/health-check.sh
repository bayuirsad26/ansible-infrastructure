#!/bin/bash
# Monitoring health check script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Configuration
NODE_EXPORTER_PORT="${NODE_EXPORTER_PORT:-9100}"
LOG_FILE="/var/log/monitoring-health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Logging function
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

log "Starting monitoring health check"

# Check Node Exporter service
if systemctl is-active --quiet node-exporter || systemctl is-active --quiet prometheus-node-exporter; then
    log "✓ Node Exporter service is running"
else
    log "✗ Node Exporter service is not running"
    exit 1
fi

# Check Node Exporter metrics endpoint
if curl -sf "http://localhost:${NODE_EXPORTER_PORT}/metrics" > /dev/null; then
    log "✓ Node Exporter metrics endpoint is responding"
else
    log "✗ Node Exporter metrics endpoint is not responding"
    exit 1
fi

# Check Docker socket access (if Docker is installed)
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null; then
        log "✓ Docker metrics access is working"
    else
        log "⚠ Docker is installed but not accessible for monitoring"
    fi
fi

# Check disk space for logs
LOG_DISK_USAGE=$(df /var/log | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$LOG_DISK_USAGE" -gt 80 ]; then
    log "⚠ Log disk usage is high: ${LOG_DISK_USAGE}%"
fi

log "Monitoring health check completed successfully"
