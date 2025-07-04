#!/bin/bash
# System Information Script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_info() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

# System Information
print_section "SYSTEM INFORMATION"
print_info "Hostname: $(hostname)"
print_info "Uptime: $(uptime -p)"
print_info "OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
print_info "Kernel: $(uname -r)"
print_info "Architecture: $(uname -m)"

# CPU Information
print_section "CPU INFORMATION"
print_info "CPU Model: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
print_info "CPU Cores: $(nproc)"
print_info "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')"

# Memory Information
print_section "MEMORY INFORMATION"
free -h | grep -E "Mem|Swap"

# Disk Information
print_section "DISK USAGE"
df -h | grep -vE '^Filesystem|tmpfs|cdrom'

# Network Information
print_section "NETWORK INTERFACES"
ip addr show | grep -E "^[0-9]+:|inet "

# Service Status
print_section "CRITICAL SERVICES STATUS"
services=("ssh" "sshd" "rsyslog" "fail2ban" "node-exporter")
for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        print_info "$service: Active"
    elif systemctl list-unit-files --state=enabled | grep -q "$service"; then
        print_warning "$service: Inactive (but enabled)"
    else
        print_error "$service: Not found or disabled"
    fi
done

# Security Information
print_section "SECURITY STATUS"
failed_attempts=$(grep "Failed password" /var/log/auth.log 2>/dev/null | grep -c "$(date '+%b %d')" || echo "0")
print_info "Failed login attempts (last 24h): $failed_attempts"
print_info "Last 5 successful logins:"
last -n 5 | head -5

# System Load
print_section "SYSTEM LOAD"
print_info "Load Average: $(awk '{print $1" "$2" "$3}' /proc/loadavg)"
print_info "Running Processes: $(ps aux | wc -l)"

# Update Information
print_section "SYSTEM UPDATES"
if command -v apt &> /dev/null; then
    updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo "0")
    print_info "Available updates (apt): $updates"
elif command -v yum &> /dev/null; then
    updates=$(yum check-update --quiet | wc -l 2>/dev/null || echo "0")
    print_info "Available updates (yum): $updates"
fi

# Certificate Information
print_section "SSL CERTIFICATES"
if [ -d "/etc/ssl/certs" ]; then
    print_info "SSL certificates directory exists"
    cert_count=$(find /etc/ssl/certs -name "*.crt" | wc -l)
    print_info "Certificate count: $cert_count"
fi

print_section "SYSTEM INFORMATION COLLECTION COMPLETE"
echo -e "${GREEN}Report generated on: $(date)${NC}"
