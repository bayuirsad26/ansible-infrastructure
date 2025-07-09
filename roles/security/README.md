# Security Role - Advanced System Hardening

Advanced security hardening with kernel parameters, audit logging, and compliance settings.

## What This Role Does

- ✅ Configures advanced kernel security parameters
- ✅ Sets up comprehensive audit logging (auditd)
- ✅ Implements security compliance settings
- ✅ Hardens file system permissions
- ✅ Configures security limits and controls
- ✅ Disables unnecessary services
- ✅ Consolidates all kernel security settings

## What This Role Doesn't Do

- ❌ Basic system setup (use common role first)
- ❌ SSH hardening (handled by common role)
- ❌ Firewall configuration (use firewall role)
- ❌ User management (use common role)

## Requirements

- Ansible >= 2.15
- Common role applied first
- Root/sudo access

## Quick Start

```yaml
- hosts: production
  become: true
  roles:
    - role: common      # Required first
    - role: security    # Advanced hardening
      security_compliance_level: "moderate"
```

## Variables

### Essential Variables

```yaml
# Compliance level determines security strictness
security_compliance_level: "basic"  # basic, moderate, strict

# Audit logging
security_enable_audit: true
security_audit_rules: "basic"

# Kernel hardening
security_kernel_hardening: true

# File system security
security_harden_filesystem: true
```

## Compliance Levels

### Basic

- Essential kernel security parameters
- Basic audit logging
- Standard file permissions

### Moderate (Recommended)

- Enhanced kernel security
- Comprehensive audit rules
- Security limits and controls
- Process monitoring

### Strict

- Maximum security hardening
- Extensive audit logging
- Strict file permissions
- Advanced security controls

## Integration

```yaml
roles:
  - role: common      # Base system (required)
  - role: security    # Advanced hardening (this role)
  - role: firewall    # Network security
  - role: monitoring  # Security monitoring
```

## License

MIT - SummitEthic DevOps Team
