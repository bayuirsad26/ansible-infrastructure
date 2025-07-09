# Logging Role - Centralized Log Management

Simplified log management and forwarding for centralized platforms like Loki or Elasticsearch.

## What This Role Does

- ✅ Configures system logging (rsyslog + journald)
- ✅ Sets up log forwarding to centralized systems
- ✅ Manages log rotation and retention
- ✅ Handles container log integration
- ✅ Automates log cleanup
- ✅ Provides simple, reliable log shipping

## What This Role Doesn't Do

- ❌ Log aggregation infrastructure (use external)
- ❌ Log analysis and parsing (use Loki/Elasticsearch)
- ❌ Log visualization (use Grafana/Kibana)
- ❌ Complex log processing (use external tools)

## Requirements

- Ansible >= 2.15
- Centralized logging endpoint (optional)
- Network access to logging server

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: logging
      logging_enable_forwarding: true
      logging_destination: "loki-server:514"
```

## Variables

### Essential Variables

```yaml
# Log forwarding
logging_enable_forwarding: false
logging_destination: "loki-server:514"
logging_protocol: "tcp"

# Container integration
logging_container_aware: true
logging_docker_logs: true

# Retention
logging_retention_days: 30
```

## Integration with Centralized Platforms

### Loki Integration

```yaml
logging_enable_forwarding: true
logging_destination: "loki-server:514"
logging_protocol: "tcp"
```

### Elasticsearch Integration

```yaml
logging_enable_forwarding: true
logging_destination: "elasticsearch-server:514"
logging_protocol: "tcp"
```

## License

MIT - SummitEthic DevOps Team
