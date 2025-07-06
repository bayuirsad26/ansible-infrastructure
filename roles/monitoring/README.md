# Monitoring Role - Observability Agents

Modern observability agent installation for metrics collection and system monitoring.

## What This Role Does

- ✅ Installs Node Exporter for Prometheus metrics
- ✅ Configures system metrics collection
- ✅ Sets up container-aware monitoring
- ✅ Provides service discovery labels
- ✅ Exposes health check endpoints
- ✅ Configures secure metrics exposure
- ✅ Enables modern observability patterns

## What This Role Doesn't Do

- ❌ Prometheus/Grafana server installation (use infrastructure tooling)
- ❌ Complex alerting rules (use dedicated alerting configuration)
- ❌ Log collection/forwarding (use logging role)
- ❌ Application monitoring (application-specific concern)
- ❌ Dashboard creation (use Grafana/visualization tools)

## Requirements

- Ansible >= 2.15
- Internet access for downloading exporters
- Modern monitoring stack (Prometheus recommended)

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: common       # Base system
    - role: monitoring   # Observability agents
```

## Variables

### Essential Variables

```yaml
# Node Exporter configuration
monitoring_node_exporter_enabled: true
monitoring_node_exporter_port: 9100

# Service discovery
monitoring_service_discovery: true
monitoring_environment: "production"

# Container monitoring
monitoring_container_aware: true

# Security
monitoring_bind_address: "0.0.0.0"  # or "127.0.0.1" for localhost only
```

## Modern Observability Integration

### Prometheus Service Discovery

```yaml
# Automatic service discovery configuration
monitoring_service_discovery: true
monitoring_labels:
  environment: "production"
  datacenter: "us-east-1"
  team: "platform"
```

### Container-Aware Monitoring

```yaml
# Docker/container integration
monitoring_container_aware: true
monitoring_docker_metrics: true
```

### Multi-Environment Support

```yaml
# Development
monitoring_environment: "development"
monitoring_node_exporter_port: 9100

# Production  
monitoring_environment: "production"
monitoring_node_exporter_port: 9100
monitoring_bind_address: "127.0.0.1"  # Secure local binding
```

## Security Features

- Secure metrics endpoint binding
- Non-privileged service execution
- Minimal required permissions
- Optional TLS support for metrics

## Integration Examples

### With Prometheus

```yaml
# Prometheus scrape config auto-generated
- job_name: 'node-exporter'
  static_configs:
    - targets: ['server1:9100', 'server2:9100']
  relabel_configs:
    - source_labels: [__address__]
      target_label: environment
      replacement: production
```

### With Docker

```yaml
# Container metrics included automatically
monitoring_container_aware: true
monitoring_docker_socket: "/var/run/docker.sock"
```

## License

MIT - SummitEthic DevOps Team
