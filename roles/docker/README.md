# Docker Role - Modern & Efficient

Installs Docker CE with security hardening for 2025 standards.

## What This Role Does

- ✅ Installs Docker CE with compose & buildx plugins
- ✅ Applies security hardening by default
- ✅ Manages users and permissions
- ✅ Configures daemon for production use

## What This Role Doesn't Do

- ❌ Monitoring (use dedicated monitoring role)
- ❌ Complex orchestration (use Kubernetes role)
- ❌ Application deployment (use playbooks)

## Requirements

- Ansible >= 2.15
- community.docker collection: `ansible-galaxy collection install community.docker`

## Quick Start

```yaml
- hosts: docker_hosts
  become: true
  roles:
    - role: docker
      docker_users: [deploy, developer]
```

## Variables

### Essential Variables

```yaml
# Users to add to docker group
docker_users: []

# Security hardening (enabled by default)
docker_security_enabled: true

# Custom daemon config (optional override)
docker_daemon_config: {}

# Service management
docker_service_state: started
docker_service_enabled: true
```

### Example with Custom Config

```yaml
- role: docker
  docker_users: [deploy, developer]
  docker_daemon_config:
    experimental: true
    metrics-addr: "127.0.0.1:9323"
    default-address-pools:
      - base: "172.18.0.0/16"
        size: 24
```

## Security Features (Enabled by Default)

- User namespace remapping (dockremap)
- Secure socket permissions
- No new privileges flag
- Production logging limits

## Example Playbooks

### Infrastructure Setup

```yaml
---
- name: Setup Docker infrastructure
  hosts: docker_hosts
  become: true
  roles:
    - role: common
    - role: docker
      docker_users: [deploy, developer]
```

### Application Deployment

```yaml
---
- name: Deploy applications
  hosts: docker_hosts
  become: true
  tasks:
    - name: Deploy web application
      community.docker.docker_compose_v2:
        project_src: /opt/apps/webapp
        state: present
      become_user: deploy
```

## License

MIT - SummitEthic DevOps Team
