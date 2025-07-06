# Firewall Role - Network Security

Modern network security configuration with OS-appropriate firewall management.

## What This Role Does

- ✅ Configures OS-appropriate firewalls (UFW/firewalld)
- ✅ Implements security-first default policies
- ✅ Manages port access with security groups style rules
- ✅ Integrates with infrastructure services automatically
- ✅ Handles container-aware networking (Docker)
- ✅ Provides basic intrusion prevention
- ✅ Enables modern cloud-native security patterns
- ✅ Automates firewall rule management

## What This Role Doesn't Do

- ❌ Complex network infrastructure setup (infrastructure tools)
- ❌ Application-specific firewall rules (application concern)
- ❌ Advanced network monitoring (monitoring role)
- ❌ VPN or tunnel configuration (separate infrastructure)
- ❌ Load balancer configuration (separate concern)
- ❌ Deep packet inspection (specialized security tools)

## Requirements

- Ansible >= 2.15
- UFW (Ubuntu/Debian) or firewalld (RedHat/CentOS)
- Root/sudo access for firewall configuration

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: common       # Base system + SSH
    - role: firewall     # Network security
```

## Variables

### Essential Variables

```yaml
# Basic firewall settings
firewall_enabled: true
firewall_default_policy: "deny"

# Infrastructure service integration
firewall_infrastructure_ports:
  - { port: 22, proto: "tcp", comment: "SSH" }
  - { port: 9100, proto: "tcp", comment: "Node Exporter" }

# Custom rules
firewall_allow_ports: []
firewall_allow_sources: []

# Container integration
firewall_docker_integration: true
```

## Security Groups Style Configuration

```yaml
# Allow specific ports (security groups style)
firewall_allow_ports:
  - { port: 80, proto: "tcp", comment: "HTTP" }
  - { port: 443, proto: "tcp", comment: "HTTPS" }
  - { port: "8000:8100", proto: "tcp", comment: "App range" }

# Allow from specific sources
firewall_allow_sources:
  - { source: "10.0.0.0/8", comment: "Private network" }
  - { source: "192.168.1.100", port: 22, comment: "Admin access" }
```

## Infrastructure Integration

```yaml
# Automatically integrates with other roles
- role: common       # Opens SSH port automatically
- role: monitoring   # Opens Node Exporter port automatically  
- role: firewall     # Applies security rules
```

## Container Awareness

```yaml
# Docker integration
firewall_docker_integration: true

# Automatically handles:
# - Docker bridge networks
# - Container port publishing
# - Docker daemon communication
```

## Cloud-Native Patterns

```yaml
# Environment-based rules
firewall_environment_rules:
  production:
    - { port: 443, proto: "tcp", source: "0.0.0.0/0" }
  development:
    - { port: 80, proto: "tcp", source: "0.0.0.0/0" }
    - { port: 443, proto: "tcp", source: "0.0.0.0/0" }
```

## License

MIT - SummitEthic DevOps Team
