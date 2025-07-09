# Docker Role - Container Platform

Modern Docker installation with security hardening and production-ready configuration.

## What This Role Does

- ✅ Installs Docker CE with compose & buildx plugins
- ✅ Applies security hardening by default
- ✅ Configures production-ready daemon settings
- ✅ Manages users and permissions
- ✅ Sets up user namespace remapping
- ✅ Configures secure logging and storage

## What This Role Doesn't Do

- ❌ Application deployment (use Docker Compose)
- ❌ Container orchestration (use Kubernetes)
- ❌ Monitoring setup (use monitoring role)
- ❌ Firewall configuration (use firewall role)

## Requirements

- Ansible >= 2.15
- community.docker collection
- Internet access for Docker repository

## Quick Start

```yaml
- hosts: docker_hosts
  become: true
  roles:
    - role: docker
      docker_users: ["deploy", "developer"]
      docker_security_enabled: true
```

## Variables

### Essential Variables

```yaml
# Users to add to docker group
docker_users: ["deploy", "developer"]

# Security hardening (recommended)
docker_security_enabled: true

# Service management
docker_service_state: started
docker_service_enabled: true
```

## Security Features

- **User Namespace Remapping**: Isolates container processes
- **Secure Daemon Configuration**: Production-ready settings
- **Log Rotation**: Prevents disk space issues
- **Security Hardening**: Default security measures

## Integration

Perfect integration with other roles:

```yaml
roles:
  - role: common      # Base system
  - role: docker      # Container platform (this role)
  - role: traefik     # Reverse proxy
  - role: monitoring  # Container monitoring
  - role: firewall    # Network security
```

## License

MIT - SummitEthic DevOps Team
