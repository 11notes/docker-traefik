![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - Traefik
![size](https://img.shields.io/docker/image-size/11notes/traefik/2.11.0?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/traefik/2.11.0?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/traefik?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-traefik?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-traefik?color=c91cb8) ![stars](https://img.shields.io/docker/stars/11notes/traefik?color=e6a50e)

**Traefik reverse proxy**

# SYNOPSIS
What can I do with this? This image will run the Traefik reverse proxy with some common presets and on alpine. This image will with the default config listen on :80 and :443 and redirect all HTTP requests to HTTPS.

# VOLUMES
* **/traefik/etc** - Directory of static config default.yaml
* **/traefik/var** - Directory of dynamic config and files

# RUN
```shell
docker run --name traefik \
  -p 80:80/tcp \
  -p 443:443/tcp \
  -v .../etc:/traefik/etc \
  -v .../var:/traefik/var \
  -d 11notes/traefik:[tag]
```

# EXAMPLES
## config /traefik/etc/default.yaml
```yaml
global:
  checkNewVersion: false
  sendAnonymousUsage: false
api:
  dashboard: true
  insecure: true

log:
  level: INFO
  format: json

providers:
  docker:
    exposedByDefault: false
  file:
    directory: /traefik/var

entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entrypoint:
          to: https
          scheme: https
          
  https:
    address: ":443"

serversTransport:
  insecureSkipVerify: true
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /traefik | home directory of user docker |
| `api` | https://${IP}:8080 | default |
| `config` | /traefik/etc/default.yaml | default configuration file |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# PARENT IMAGE
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH
* [traefik](https://traefik.io/traefik)
* [alpine](https://alpinelinux.org)

# TIPS
* Only use rootless container runtime (podman, rootless docker)
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=53" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes.
    