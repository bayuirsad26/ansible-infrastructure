#!/bin/bash
# Firewall status monitoring script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}$1${NC}"
}

log_warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

log_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Detect OS and firewall type
if command -v ufw &> /dev/null; then
    FIREWALL_TYPE="ufw"
elif command -v firewall-cmd &> /dev/null; then
    FIREWALL_TYPE="firewalld"
else
    log_error "No supported firewall found"
    exit 1
fi

log "Checking $FIREWALL_TYPE firewall status"

case $FIREWALL_TYPE in
    "ufw")
        if ufw status | grep -q "Status: active"; then
            log "✓ UFW firewall is active"
            
            # Check rules count
            RULES_COUNT=$(ufw status numbered | grep -c "^\[" || echo "0")
            log "✓ Active rules: $RULES_COUNT"
            
            # Check for SSH access
            if ufw status | grep -q "22/tcp\|OpenSSH"; then
                log "✓ SSH access is configured"
            else
                log_warn "SSH access rule not found"
            fi
            
            # Show status
            echo "--- UFW Status ---"
            ufw status --numbered
            
        else
            log_error "UFW firewall is not active"
            exit 1
        fi
        ;;
        
    "firewalld")
        if firewall-cmd --state &> /dev/null; then
            log "✓ firewalld is active"
            
            # Check default zone
            DEFAULT_ZONE=$(firewall-cmd --get-default-zone)
            log "✓ Default zone: $DEFAULT_ZONE"
            
            # Show status
            echo "--- firewalld Status ---"
            firewall-cmd --list-all
            
        else
            log_error "firewalld is not running"
            exit 1
        fi
        ;;
esac

log "Firewall status check completed"
