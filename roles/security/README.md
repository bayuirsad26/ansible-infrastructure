# Security Role - Advanced Hardening

Advanced security hardening for production systems following 2025 best practices.

## What This Role Does

- ✅ Advanced kernel security parameters
- ✅ Audit logging (auditd) configuration
- ✅ Security compliance settings (CIS benchmarks)
- ✅ AppArmor/SELinux hardening
- ✅ Advanced file permissions and ownership
- ✅ Security scanning and vulnerability checks
- ✅ Intrusion detection basics

## What This Role Doesn't Do

- ❌ Basic SSH hardening (use common role)
- ❌ User management (use common role)
- ❌ Firewall configuration (use firewall role)
- ❌ Monitoring setup (use monitoring role)
- ❌ Log infrastructure (use logging role)

## Requirements

- Ansible >= 2.15
- Common role applied first
- Root/sudo access

## Quick Start

```yaml
- hosts: production
  become: true
  roles:
    - role: common      # Apply first
    - role: security    # Advanced hardening
```

## Variables

### Essential Variables

```yaml
# Audit logging
security_enable_audit: true
security_audit_rules: "strict"  # strict, moderate, basic

# Kernel hardening
security_kernel_hardening: true

# Compliance level
security_compliance_level: "moderate"  # strict, moderate, basic

# Security scanning
security_enable_scanning: true
```

## Compliance Levels

### Basic

- Essential kernel parameters
- Basic audit logging
- Standard file permissions

### Moderate (Default)

- Enhanced kernel security
- Comprehensive audit rules
- Security limits and controls
- Basic intrusion detection

### Strict

- Maximum security hardening
- Extensive audit logging
- Strict file permissions
- Advanced security controls

## Example Usage

### Production Environment

```yaml
- role: security
  security_compliance_level: "strict"
  security_enable_audit: true
  security_kernel_hardening: true
```

### Development Environment

```yaml
- role: security
  security_compliance_level: "basic"
  security_enable_scanning: false
```

## Integration with Other Roles

```yaml
roles:
  - role: common      # Base system setup
  - role: security    # Advanced hardening (this role)
  - role: firewall    # Network security
  - role: monitoring  # Security monitoring
```

## License

MIT - SummitEthic DevOps Team
