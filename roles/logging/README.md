# Logging Role - Centralized Log Management

Modern log management, rotation, and forwarding for centralized logging systems.

## What This Role Does

- ✅ Configures system logging (rsyslog/journald)
- ✅ Sets up log rotation policies
- ✅ Configures log forwarding to centralized systems
- ✅ Enables structured logging (JSON format)
- ✅ Manages container log integration (Docker)
- ✅ Handles security event logging
- ✅ Automates log retention and cleanup
- ✅ Installs modern log shippers (Vector/Fluent Bit)

## What This Role Doesn't Do

- ❌ Log aggregation infrastructure (ELK/Loki servers)
- ❌ Complex log analysis and parsing (analytics tools)
- ❌ Log visualization and dashboards (Grafana/Kibana)
- ❌ Application-specific logging (application concern)
- ❌ Log monitoring and alerting (monitoring role)
- ❌ Log storage infrastructure (infrastructure deployment)

## Requirements

- Ansible >= 2.15
- Internet access for downloading log shippers
- Centralized logging endpoint (optional)

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: common       # Base system
    - role: logging      # Log management
```

## Variables

### Essential Variables

```yaml
# Log forwarding
logging_enable_forwarding: true
logging_destination: "logs.example.com:514"

# Log shipper choice
logging_shipper: "vector"  # vector, fluent-bit, rsyslog

# Log format
logging_format: "json"     # json, traditional

# Container logging
logging_container_aware: true

# Log retention
logging_retention_days: 30
```

## Modern Log Shipping

### Vector (Recommended)

```yaml
logging_shipper: "vector"
logging_vector_config:
  inputs:
    - system_logs
    - docker_logs
  outputs:
    - elasticsearch
    - loki
```

### Fluent Bit

```yaml
logging_shipper: "fluent-bit"
logging_fluent_bit_outputs:
  - type: elasticsearch
    host: logs.example.com
    port: 9200
```

### Traditional Rsyslog

```yaml
logging_shipper: "rsyslog"
logging_rsyslog_remote: "logs.example.com:514"
```

## Structured Logging

```yaml
# JSON format for modern log analysis
logging_format: "json"
logging_json_fields:
  - timestamp
  - hostname
  - service
  - level
  - message
```

## Container Integration

```yaml
# Docker log management
logging_container_aware: true
logging_docker_driver: "json-file"
logging_docker_options:
  max-size: "10m"
  max-file: "3"
```

## License

MIT - SummitEthic DevOps Team
