# Common Role - Essential System Foundation

Modern base system configuration with security hardening, fail2ban, and automatic updates.

## What This Role Does

- ✅ Installs essential packages and security tools
- ✅ Creates admin users with SSH keys and sudo access
- ✅ Hardens SSH configuration with security best practices
- ✅ Configures fail2ban for intrusion prevention
- ✅ Enables automatic security updates
- ✅ Sets up system basics (timezone, hostname)
- ✅ Provides secure foundation for other roles

## What This Role Doesn't Do

- ❌ Advanced security hardening (use security role)
- ❌ Monitoring setup (use monitoring role)
- ❌ Firewall configuration (use firewall role)
- ❌ Container platform (use docker role)

## Requirements

- Ansible >= 2.15
- Root/sudo access on target systems
- SSH key for admin user access

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
# Admin users with SSH access
common_admin_users:
  - name: admin
    ssh_keys:
      - "ssh-rsa AAAAB3... admin@summitethic.com"
    sudo_nopasswd: false

# System configuration
common_timezone: "UTC"
common_hostname: "{{ inventory_hostname }}"

# SSH security
common_ssh_port: 22
common_disable_root_login: true
common_ssh_password_auth: false

# Security features
common_enable_fail2ban: true
common_enable_auto_updates: true
```

## Security Features

- **SSH Hardening**: Disabled root login, key-only authentication, rate limiting
- **Fail2ban**: Automatic intrusion detection and prevention
- **Auto Updates**: Automatic security updates for Ubuntu/Debian
- **User Management**: Secure sudo configuration
- **Package Management**: Essential security packages

## Integration

This role provides the foundation for other roles:

```yaml
roles:
  - role: common      # Base system (this role)
  - role: security    # Advanced hardening
  - role: docker      # Container platform
  - role: monitoring  # Observability
  - role: firewall    # Network security
```

## License

MIT - SummitEthic DevOps Team
