# Monitoring Role - Observability Agent

Node Exporter installation for Prometheus metrics collection with package manager preference.

## What This Role Does

- ✅ Installs Node Exporter (package manager first, manual fallback)
- ✅ Configures system metrics collection
- ✅ Sets up container-aware monitoring
- ✅ Provides service discovery configuration
- ✅ Exposes secure metrics endpoints
- ✅ Enables modern observability patterns

## What This Role Doesn't Do

- ❌ Prometheus server installation (use external)
- ❌ Grafana dashboard setup (use external)
- ❌ Log collection (use logging role)
- ❌ Application monitoring (application concern)

## Requirements

- Ansible >= 2.15
- Internet access for manual download (fallback)
- Prometheus server for metrics collection

## Quick Start

```yaml
- hosts: all
  become: true
  roles:
    - role: monitoring
      monitoring_bind_address: "0.0.0.0"  # For external Prometheus
```

## Variables

### Essential Variables

```yaml
# Node Exporter configuration
monitoring_node_exporter_enabled: true
monitoring_node_exporter_port: 9100

# Binding address
monitoring_bind_address: "0.0.0.0"  # or "127.0.0.1" for local only

# Container monitoring
monitoring_container_aware: true
monitoring_docker_metrics: true

# Package preference
monitoring_prefer_package: true
```

## Integration with Centralized Platforms

### Prometheus Configuration

```yaml
# Prometheus scrape config
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['server1:9100', 'server2:9100']
```

### Firewall Integration

```yaml
# Automatically opens port 9100 when using firewall role
firewall_monitoring_sources: "prometheus-server-ip"
```

## License

MIT - SummitEthic DevOps Team
