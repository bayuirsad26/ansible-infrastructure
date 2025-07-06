#!/bin/bash
# Traefik status monitoring script
# Managed by Ansible - Do not edit manually

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
TRAEFIK_CONTAINER="traefik"
TRAEFIK_NETWORK="traefik"
DASHBOARD_PORT="8080"

log() {
    echo -e "${GREEN}$1${NC}"
}

log_warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

log_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

log "Checking Traefik status"

# Check if Traefik container is running
if docker ps --format "table {{.Names}}" | grep -q "^${TRAEFIK_CONTAINER}$"; then
    log "✓ Traefik container is running"
    
    # Check container health
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' ${TRAEFIK_CONTAINER} 2>/dev/null || echo "no-health-check")
    if [ "$HEALTH" = "healthy" ]; then
        log "✓ Traefik container is healthy"
    elif [ "$HEALTH" = "no-health-check" ]; then
        log_warn "Traefik container has no health check"
    else
        log_error "Traefik container is unhealthy: $HEALTH"
    fi
    
    # Check if API is responding
    if curl -sf "http://localhost:${DASHBOARD_PORT}/ping" > /dev/null; then
        log "✓ Traefik API is responding"
    else
        log_error "Traefik API is not responding"
    fi
    
    # Check network exists
    if docker network ls | grep -q "${TRAEFIK_NETWORK}"; then
        log "✓ Traefik network exists"
    else
        log_error "Traefik network '${TRAEFIK_NETWORK}' not found"
    fi
    
    # Show connected services
    SERVICES=$(docker ps --filter "network=${TRAEFIK_NETWORK}" --format "{{.Names}}" | grep -v "^${TRAEFIK_CONTAINER}$" | wc -l)
    log "✓ Connected services: $SERVICES"
    
    # Check Let's Encrypt certificates
    if [ -d "/var/lib/traefik/letsencrypt" ]; then
        if [ -f "/var/lib/traefik/letsencrypt/acme.json" ]; then
            CERTS=$(grep -o '"domain"' /var/lib/traefik/letsencrypt/acme.json 2>/dev/null | wc -l || echo "0")
            log "✓ Let's Encrypt certificates: $CERTS"
        else
            log_warn "Let's Encrypt not configured or no certificates yet"
        fi
    fi
    
else
    log_error "Traefik container is not running"
    exit 1
fi

log "Traefik status check completed"
