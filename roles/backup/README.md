# Backup Role - Simplified Data Protection

Basic backup solution focusing on essential data protection needs.

## What This Role Does

- ✅ Automated system backups using rsync
- ✅ Container volume backups
- ✅ Simple retention policies
- ✅ Local backup storage
- ✅ Optional cloud integration
- ✅ Automated scheduling

## What This Role Doesn't Do

- ❌ Complex backup infrastructure (use dedicated tools)
- ❌ Application-specific backup logic (application concern)
- ❌ Backup restoration procedures (operational concern)
- ❌ Complex cloud orchestration (use specialized tools)

## Requirements

- Ansible >= 2.15
- Local storage for backups
- Optional cloud storage credentials

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: backup
      backup_enabled: true
      backup_local_path: "/var/backups"
```

## Variables

### Essential Variables

```yaml
# Basic configuration
backup_enabled: true
backup_local_path: "/var/backups"

# System paths to backup
backup_system_paths:
  - "/etc"
  - "/home"
  - "/var/log"

# Container backups
backup_docker_enabled: true
backup_docker_volumes: true

# Retention
backup_retention_days: 7
```

## Integration

Works seamlessly with other roles:

```yaml
roles:
  - role: docker      # Provides container integration
  - role: backup      # Backs up Docker volumes
```

## License

MIT - SummitEthic DevOps Team
