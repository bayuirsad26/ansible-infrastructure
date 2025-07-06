# Traefik Role - Container-Native Reverse Proxy

Modern reverse proxy and load balancer designed specifically for containerized applications.

## What This Role Does

- ✅ Deploys Traefik as a Docker container
- ✅ Configures automatic service discovery
- ✅ Sets up Let's Encrypt SSL automation
- ✅ Enables container-based routing via labels
- ✅ Provides real-time metrics and monitoring
- ✅ Implements security headers and rate limiting
- ✅ Handles load balancing and health checks
- ✅ Zero-downtime configuration updates

## What This Role Doesn't Do

- ❌ Static file serving (use dedicated containers)
- ❌ Application deployment (use Docker Compose/Kubernetes)
- ❌ Complex application logic (application concern)
- ❌ Database or cache management (separate concerns)

## Requirements

- Ansible >= 2.15
- Docker role applied first
- Domain names pointing to server
- Email for Let's Encrypt registration

## Quick Start

```yaml
- hosts: docker_hosts
  become: true
  roles:
    - role: docker      # Must be applied first
    - role: traefik
      traefik_domain: "summitethic.com"
      traefik_email: "admin@summitethic.com"
```

## Variables

### Essential Variables

```yaml
# Basic configuration
traefik_enabled: true
traefik_domain: "example.com"
traefik_email: "admin@example.com"

# Network configuration
traefik_network: "traefik"
traefik_web_port: 80
traefik_websecure_port: 443

# Dashboard access
traefik_dashboard_enabled: true
traefik_dashboard_subdomain: "traefik"

# Let's Encrypt
traefik_letsencrypt_enabled: true
traefik_letsencrypt_staging: false
```

## Container-Native Routing

### Automatic Service Discovery

```yaml
# Your application containers just need labels:
version: '3.8'
services:
  webapp:
    image: summitethic/webapp:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.webapp.rule=Host(`app.summitethic.com`)"
      - "traefik.http.routers.webapp.tls.certresolver=letsencrypt"
      - "traefik.http.services.webapp.loadbalancer.server.port=8080"
```

### Advanced Routing

```yaml
# Multiple domains, path-based routing, middleware
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.api.rule=Host(`api.summitethic.com`) && PathPrefix(`/v1`)"
  - "traefik.http.routers.api.tls.certresolver=letsencrypt"
  - "traefik.http.routers.api.middlewares=auth,ratelimit"
  - "traefik.http.middlewares.auth.basicauth.users=admin:$$2y$$10$$..."
  - "traefik.http.middlewares.ratelimit.ratelimit.burst=100"
```

## Integration with Infrastructure

```yaml
# Perfect integration with your existing roles
- role: common      # Base system + SSH
- role: security    # Advanced hardening
- role: docker      # Container platform (required)
- role: monitoring  # Observability (metrics integration)
- role: logging     # Log management (structured logs)
- role: firewall    # Network security (opens 80/443)
- role: traefik     # Container reverse proxy (this role)
```

## Modern Benefits

- **Zero Configuration**: Automatic service discovery via Docker labels
- **SSL Automation**: Let's Encrypt certificates with auto-renewal
- **Dynamic Updates**: Add/remove services without restart
- **Container-Native**: Built for modern containerized infrastructure
- **Monitoring Ready**: Built-in Prometheus metrics
- **Security First**: Automatic security headers, rate limiting

## License

MIT - SummitEthic DevOps Team
