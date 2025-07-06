# Common Role - Modern & Efficient

Essential base system configuration and security hardening.

## What This Role Does
- ✅ Installs essential packages
- ✅ Creates admin users with SSH keys
- ✅ Hardens SSH configuration
- ✅ Applies basic security settings
- ✅ Sets up system basics (timezone, hostname)

## What This Role Doesn't Do
- ❌ Monitoring (use dedicated monitoring role)
- ❌ Logging (use dedicated logging role)
- ❌ Firewall (use dedicated firewall role)
- ❌ Complex security audit (use dedicated security role)

## Requirements
- Ansible >= 2.15
- Target: Ubuntu 20.04+, RHEL/CentOS 8+, Debian 11+

## Quick Start
```yaml
- hosts: all
  become: true
  roles:
    - role: common
      common_admin_users:
        - name: admin
          ssh_keys:
            - "ssh-rsa AAAAB3... admin@summitethic.com"
```

## Variables

### Essential Variables
```yaml
# Admin users to create
common_admin_users: []

# Essential packages to install
common_packages: []  # Uses sensible defaults

# System settings
common_timezone: "UTC"
common_ssh_port: 22

# Security settings (enabled by default)
common_harden_ssh: true
common_disable_root_login: true
```

## Example Usage
```yaml
- role: common
  common_admin_users:
    - name: devops
      ssh_keys:
        - "ssh-rsa AAAAB3... devops@summitethic.com"
    - name: deploy
      ssh_keys:
        - "ssh-rsa AAAAB3... deploy@summitethic.com"
  common_timezone: "Asia/Jakarta"
  common_packages:
    - git
    - curl
    - htop
```

## Security Features (Enabled by Default)
- SSH hardening (disable root, key-only auth)
- Secure sudo configuration
- Essential security packages
- Basic system hardening

## License
MIT - SummitEthic DevOps Team
