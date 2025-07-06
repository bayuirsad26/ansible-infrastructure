# Backup Role - Automated Data Protection

Modern automated backup solution with cloud-native storage and container awareness.

## What This Role Does
- ✅ Configures automated system backups
- ✅ Cloud storage integration (S3, GCS, Azure Blob)
- ✅ Container-aware backups (Docker volumes)
- ✅ Database backup automation
- ✅ Backup verification and integrity checking
- ✅ Retention policy management
- ✅ Encrypted backup storage
- ✅ Backup monitoring and alerting

## What This Role Doesn't Do
- ❌ Complex backup infrastructure setup (use backup services)
- ❌ Application-specific backup logic (application concern)
- ❌ Backup restoration procedures (operational concern)
- ❌ Backup storage infrastructure (infrastructure concern)
- ❌ Complex backup orchestration (specialized tools)

## Requirements
- Ansible >= 2.15
- Cloud storage credentials (S3, GCS, Azure)
- Root/sudo access for system backups

## Quick Start
```yaml
- hosts: all
  become: true
  roles:
    - role: common       # Base system
    - role: backup       # Data protection
```

## Variables

### Essential Variables
```yaml
# Backup configuration
backup_enabled: true
backup_tool: "restic"  # restic, rclone, rsync

# Cloud storage
backup_destination: "s3:bucket-name/path"
backup_retention_days: 30

# Backup schedules
backup_system_schedule: "0 2 * * *"    # Daily at 2 AM
backup_docker_schedule: "0 3 * * *"    # Daily at 3 AM

# What to backup
backup_system_paths: ["/etc", "/home", "/var/log"]
backup_docker_volumes: true
backup_databases: []
```

## Modern Cloud Storage Integration
```yaml
# AWS S3
backup_destination: "s3:summitethic-backups/production"
backup_aws_access_key: "{{ vault_aws_access_key }}"
backup_aws_secret_key: "{{ vault_aws_secret_key }}"

# Google Cloud Storage
backup_destination: "gs:summitethic-backups/production"
backup_gcs_credentials: "/etc/backup/gcs-credentials.json"

# Azure Blob Storage
backup_destination: "azure:summitethic-backups/production"
backup_azure_account: "{{ vault_azure_account }}"
backup_azure_key: "{{ vault_azure_key }}"
```

## Container-Aware Backups
```yaml
# Docker integration
backup_docker_volumes: true
backup_docker_configs: true
backup_docker_compose_dirs: ["/opt/apps"]
```

## Database Backups
```yaml
backup_databases:
  - name: "app_database"
    type: "postgresql"
    host: "localhost"
    database: "app_db"
    schedule: "0 1 * * *"
```

## Retention and Security
```yaml
backup_retention_days: 30
backup_encryption: true
backup_compression: true
backup_verification: true
```

## License
MIT - SummitEthic DevOps Team
