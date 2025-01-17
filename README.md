![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - Traefik
![size](https://img.shields.io/docker/image-size/11notes/traefik/3.2.0?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/traefik/3.2.0?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/traefik?color=2b75d6)

**Traefik reverse proxy**

# SYNOPSIS
**What can I do with this?** This image will run the Traefik reverse proxy with some common presets and on alpine. This image will with the default config listen on :80 and :443 and redirect all HTTP requests to HTTPS.

# VOLUMES
* **/traefik/var** - Directory of dynamic config and files

# COMPOSE
```yaml
name: "traefik"
services:
  redis:
    image: "11notes/redis:7.4.0"
    container_name: "redis"
    environment:
      TZ: "Europe/Zurich"
      REDIS_PASSWORD: "redis"
    command:
      # default errors
      - "SET traefik/http/services/error/loadbalancer/servers/0/url https://error:8443"
      - "SET traefik/http/middlewares/default.error/errors/status 402-599"
      - "SET traefik/http/middlewares/default.error/errors/service error@redis"
      - "SET traefik/http/middlewares/default.error/errors/query /{status}"

      # default http to https
      - "SET traefik/http/middlewares/default.http/redirectscheme/permanent true"
      - "SET traefik/http/middlewares/default.http/redirectscheme/scheme https"
      - "SET traefik/http/routers/default.http/priority 1"
      - "SET traefik/http/routers/default.http/rule PathPrefix(`/`)"
      - "SET traefik/http/routers/default.http/entrypoints http"
      - "SET traefik/http/routers/default.http/middlewares/0 default.http"
      - "SET traefik/http/routers/default.http/service default.http@redis"
      - "SET traefik/http/services/default.http/loadbalancer/passhostheader true"

      # default router
      - "SET traefik/http/services/static/loadbalancer/servers/0/url https://static:8443"
      - "SET traefik/http/routers/default/entrypoints https"
      - "SET traefik/http/routers/default/tls true"
      - "SET traefik/http/routers/default/priority 1"
      - "SET traefik/http/routers/default/rule PathPrefix(`/`)"
      - "SET traefik/http/routers/default/service static@redis"

      # default ratelimit
      - "SET traefik/http/middlewares/default.ratelimit/ratelimit/average 100"
      - "SET traefik/http/middlewares/default.ratelimit/ratelimit/burst 120"
      - "SET traefik/http/middlewares/default.ratelimit/ratelimit/period 1s"

      # default allowlist
      - "SET traefik/http/middlewares/default.ipallowlist.RFC1918/ipallowlist/sourcerange 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
    volumes:
      - "redis.etc:/redis/etc"
      - "redis.var:/redis/var"
    networks:
      - "backend"
    restart: "always"

  redis-insight:
    depends_on:
      redis:
        condition: "service_healthy"
        restart: true
    image: "11notes/redis-insight:2.58.0"
    container_name: "redis-insight"
    environment:
      TZ: Europe/Zurich
    ports:
      - "5540:5540/tcp"
    volumes:
      - "redis-insight.var:/redis-insight/var"
    networks:
      - "backend"
      - "frontend"
    restart: always

  static:
    image: "11notes/nginx:stable"
    container_name: "static"
    environment:
      TZ: "Europe/Zurich"
      NGINX_DYNAMIC_RELOAD: true
    volumes:
      - "static.etc:/nginx/etc"
      - "static.var:/nginx/var"
      - "static.ssl:/nginx/ssl"
    networks:
      - "backend"
    restart: "always"

  error:
    image: "11notes/traefik:error"
    container_name: "error"
    environment:
      TZ: "Europe/Zurich"
    volumes:
      - "error.var:/node"
    networks:
      - "backend"
    restart: "always"

  traefik:
    depends_on:
      redis:
        condition: "service_healthy"
        restart: true
    image: "11notes/traefik:3.2.0"
    container_name: "traefik"
    environment:
      TZ: "Europe/Zurich"
    command:
      - "--global.checkNewVersion=false"
      - "--global.sendAnonymousUsage=false"
      - "--api.dashboard=true"
      - "--api.insecure=true"
      - "--log.level=INFO"
      - "--log.format=json"
      - "--providers.file.directory=/traefik/var"
      - "--providers.redis.endpoints=redis:6379"
      - "--providers.redis.password=redis"
      - "--entrypoints.http.address=:80"
      - "--entrypoints.https.http.middlewares=default.error@redis,default.ratelimit@redis"
      - "--entrypoints.https.address=:443"
      - "--entrypoints.https.http.middlewares=default.error@redis,default.ratelimit@redis"
      - "--serversTransport.insecureSkipVerify=true"
    ports:
      - "80:80/tcp"
      - "443:443/tcp"
      - "8080:8080/tcp"
    volumes:
      - "var:/traefik/var"
    networks:
      - "backend"
      - "frontend"
    sysctls:
      - net.ipv4.ip_unprivileged_port_start=80
    restart: "always"
volumes:
  redis.etc:
  redis.var:
  redis-insight.var:
  static.etc:
  static.var:
  static.ssl:
  error.var:
  var:
networks:
  frontend:
  backend:
    internal: true
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /traefik | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# SOURCE
* [11notes/traefik:3.2.0](https://github.com/11notes/docker-traefik/tree/3.2.0)

# PARENT IMAGE
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH
* [traefik](https://traefik.io/traefik)
* [alpine](https://alpinelinux.org)

# TIPS
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes. You can find all my repositories on [github](https://github.com/11notes).
    