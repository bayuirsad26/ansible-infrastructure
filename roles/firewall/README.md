# Firewall Role - Auto-Integrated Network Security

Modern firewall configuration with automatic service discovery and OS-appropriate management.

## What This Role Does

- ✅ Configures OS-appropriate firewalls (UFW/firewalld)
- ✅ Automatically discovers services from other roles
- ✅ Implements security-first default policies
- ✅ Handles container-aware networking
- ✅ Provides rate limiting and logging
- ✅ Enables cloud-native security patterns

## What This Role Doesn't Do

- ❌ Complex network infrastructure (use specialized tools)
- ❌ Application-specific rules (application concern)
- ❌ Advanced network monitoring (use monitoring role)
- ❌ VPN configuration (separate infrastructure)

## Requirements

- Ansible >= 2.15
- UFW (Ubuntu/Debian) or firewalld (RedHat/CentOS)
- Root/sudo access

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: common      # Provides SSH port info
    - role: monitoring  # Provides metrics port info
    - role: firewall    # Auto-discovers and configures
```

## Variables

### Essential Variables

```yaml
# Basic configuration
firewall_enabled: true
firewall_default_policy: "deny"

# Source restrictions
firewall_ssh_sources: "0.0.0.0/0"
firewall_monitoring_sources: "127.0.0.1"

# Container integration
firewall_docker_integration: true

# Rate limiting
firewall_enable_rate_limiting: true
```

## Auto-Discovery Features

The firewall role automatically discovers and configures:

- **SSH Port**: From common role configuration
- **Node Exporter**: From monitoring role configuration
- **Traefik Ports**: From traefik role configuration
- **Custom Services**: From other role variables

## Security Features

- **Default Deny**: Secure by default policy
- **Rate Limiting**: SSH brute force protection
- **Container Integration**: Docker-aware networking
- **Logging**: Security event logging

## License

MIT - SummitEthic DevOps Team
