# Traefik Role - Container-Native Reverse Proxy

Modern reverse proxy with automatic SSL, service discovery, and container-native design.

## What This Role Does

- ✅ Deploys Traefik as Docker container
- ✅ Configures automatic service discovery
- ✅ Sets up Let's Encrypt SSL automation
- ✅ Enables container-based routing via labels
- ✅ Provides security headers and rate limiting
- ✅ Handles load balancing and health checks

## What This Role Doesn't Do

- ❌ Application deployment (use Docker Compose)
- ❌ Static file serving (use dedicated containers)
- ❌ Complex application logic (application concern)
- ❌ Database management (separate concerns)

## Requirements

- Ansible >= 2.15
- Docker role applied first
- Domain names pointing to server
- Email for Let's Encrypt registration

## Quick Start

```yaml
- hosts: web_servers
  become: true
  roles:
    - role: docker      # Required first
    - role: traefik
      traefik_domain: "summitethic.com"
      traefik_email: "admin@summitethic.com"
```

## Variables

### Essential Variables

```yaml
# Basic configuration
traefik_domain: "summitethic.com"
traefik_email: "admin@summitethic.com"

# Network ports
traefik_web_port: 80
traefik_websecure_port: 443

# Dashboard
traefik_dashboard_enabled: true
traefik_dashboard_subdomain: "traefik"

# SSL automation
traefik_letsencrypt_enabled: true
traefik_letsencrypt_staging: false
```

## Container Integration

Applications just need Docker labels:

```yaml
services:
  webapp:
    image: myapp:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.webapp.rule=Host(`app.summitethic.com`)"
      - "traefik.http.routers.webapp.tls.certresolver=letsencrypt"
```

## Modern Benefits

- **Zero Configuration**: Automatic service discovery
- **SSL Automation**: Let's Encrypt with auto-renewal
- **Dynamic Updates**: Add/remove services without restart
- **Container-Native**: Built for modern infrastructure
- **Security First**: Automatic security headers

## License

MIT - SummitEthic DevOps Team
