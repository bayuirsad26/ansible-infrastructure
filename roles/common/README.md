# Common Role

Base configuration role for all servers in the infrastructure.

## Description

This role provides essential system configuration including:
- Package management and updates
- User and SSH configuration  
- Security hardening
- Firewall setup
- Monitoring agent installation
- Logging configuration
- System optimization

## Requirements

- Ansible >= 2.15
- Target systems: Ubuntu 20.04+, RHEL/CentOS 8+, Debian 11+
- Sudo access on target systems

## Dependencies

- community.general
- ansible.posix
- community.crypto

## Example Playbook

```yaml
- hosts: all
  become: yes
  roles:
    - role: common
      common_admin_users:
        - name: admin
          groups: ["sudo"]
          ssh_keys:
            - "ssh-rsa AAAAB3... admin@example.com"
      common_enable_firewall: true
      common_firewall_allowed_ports:
        - "22/tcp"
        - "80/tcp"
        - "443/tcp"
```

## License

MIT

## Author Information

DevOps Team - Nusatech Development
