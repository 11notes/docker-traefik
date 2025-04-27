![banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# TRAEFIK
[<img src="https://img.shields.io/badge/github-source-blue?logo=github&color=040308">](https://github.com/11notes/docker-TRAEFIK)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![size](https://img.shields.io/docker/image-size/11notes/traefik/3.3.5?color=0eb305)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![version](https://img.shields.io/docker/v/11notes/traefik/3.3.5?color=eb7a09)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![pulls](https://img.shields.io/docker/pulls/11notes/traefik?color=2b75d6)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)[<img src="https://img.shields.io/github/issues/11notes/docker-TRAEFIK?color=7842f5">](https://github.com/11notes/docker-TRAEFIK/issues)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![swiss_made](https://img.shields.io/badge/Swiss_Made-FFFFFF?labelColor=FF0000&logo=data:image/svg%2bxml;base64,PHN2ZyB2ZXJzaW9uPSIxIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Im0wIDBoMzJ2MzJoLTMyeiIgZmlsbD0iI2YwMCIvPjxwYXRoIGQ9Im0xMyA2aDZ2N2g3djZoLTd2N2gtNnYtN2gtN3YtNmg3eiIgZmlsbD0iI2ZmZiIvPjwvc3ZnPg==)

Run traefik rootless, distroless and secure by default!

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [3.3.5](https://hub.docker.com/r/11notes/traefik/tags?name=3.3.5)
* [latest](https://hub.docker.com/r/11notes/traefik/tags?name=latest)

# REPOSITORIES ☁️
```
docker pull 11notes/traefik:3.3.5
docker pull ghcr.io/11notes/traefik:3.3.5
docker pull quay.io/11notes/traefik:3.3.5
```

# SYNOPSIS 📖
**What can I do with this?** Run the prefer IaC reverse proxy distroless and rootless for maximum security.

# UNIQUE VALUE PROPOSITION 💶
**Why should I run this image and not the other image(s) that already exist?** Good question! All the other images on the market that do exactly the same don’t do or offer these options:

> [!IMPORTANT]
>* This image runs as 1000:1000 by default, most other images run everything as root
>* This image has no shell since it is 100% distroless, most other images run on a distro like Debian or Alpine with full shell access (security)
>* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
>* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
>* This image works as read-only, most other images need to write files to the image filesystem
>* This image is a lot smaller than most other images

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

# COMPARISON 🏁
Below you find a comparison between this image and traefik:3.3.5.

Difference in image size:
```
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
11notes/traefik   3.3.5     6309cc585eb6   31 hours ago   54.9MB
traefik           3.3.5     66c037adf0b4   3 weeks ago    221MB

```

# VOLUMES 📁
* **/traefik/var** - Directory of all dynamic data and configurations

# COMPOSE ✂️
```yaml
name: "reverse-proxy"
services:
  socket-proxy:
    # this image is used to expose the docker socket as read-only to traefik
    # you can check https://github.com/11notes/docker-socket-proxy for all details
    image: "11notes/socket-proxy:2.1.2"
    read_only: true
    user: "0:0" 
    environment:
      TZ: "Europe/Zurich"
    volumes:
      - "/run/docker.sock:/run/docker.sock:ro" 
      - "socket-proxy.run:/run/proxy"
    restart: "always"

  errors:
    # this image can be used to display a simple error message since Traefik can’t serve content
    image: "11notes/traefik:errors"
    read_only: true
    labels:
      - "traefik.enable=true"
      - "traefik.http.services.default-errors.loadbalancer.server.port=8080"
    environment:
      TZ: "Europe/Zurich"
    networks:
      backend:
    restart: "always"

  traefik:
    image: "11notes/traefik:3.3.5"
    read_only: true
    labels:
      - "traefik.enable=true"

      # example on how to secure the traefik dashboard and api
      - "traefik.http.routers.dashboard.rule=Host(`${TRAEFIK_FQDN}`)"
      - "traefik.http.routers.dashboard.service=api@internal"
      - "traefik.http.routers.dashboard.middlewares=dashboard-auth"
      - "traefik.http.routers.dashboard.entrypoints=https"
      - "traefik.http.routers.dashboard.tls=true"
      - "traefik.http.middlewares.dashboard-auth.basicauth.users=admin:$2a$12$ktgZsFQZ0S1FeQbI1JjS9u36fAJMHDQaY6LNi9EkEp8sKtP5BK43C" # admin / traefik, please change!

      # default ratelimit
      - "traefik.http.middlewares.default-ratelimit.ratelimit.average=100"
      - "traefik.http.middlewares.default-ratelimit.ratelimit.burst=120"
      - "traefik.http.middlewares.default-ratelimit.ratelimit.period=1s"

      # default allowlist
      - "traefik.http.middlewares.default-ipallowlist-RFC1918.ipallowlist.sourcerange=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"

      # default catch-all router
      - "traefik.http.routers.default.rule=HostRegexp(`.+`)"
      - "traefik.http.routers.default.priority=1"
      - "traefik.http.routers.default.entrypoints=https"
      - "traefik.http.routers.default.tls=true"
      - "traefik.http.routers.default.service=default-errors"

      # default http to https
      # if you need a http website, don't worry, this router has priority 1
      - "traefik.http.middlewares.default-http.redirectscheme.permanent=true"
      - "traefik.http.middlewares.default-http.redirectscheme.scheme=https"
      - "traefik.http.routers.default-http.priority=1"
      - "traefik.http.routers.default-http.rule=HostRegexp(`.+`)"
      - "traefik.http.routers.default-http.entrypoints=http"
      - "traefik.http.routers.default-http.middlewares=default-http"
      - "traefik.http.routers.default-http.service=default-http"
      - "traefik.http.services.default-http.loadbalancer.passhostheader=true"

      # default errors
      - "traefik.http.middlewares.default-errors.errors.status=402-599"
      - "traefik.http.middlewares.default-errors.errors.query=/{status}"
      - "traefik.http.middlewares.default-errors.errors.service=default-errors"
    depends_on:
      socket-proxy:
        condition: "service_healthy"
        restart: true
    environment:
      TZ: "Europe/Zurich"
    command:
      - "--ping.terminatingStatusCode=204" # ping is needed for the health check to work!
      - "--global.checkNewVersion=false"
      - "--global.sendAnonymousUsage=false"
      - "--accesslog=true"
      - "--api.dashboard=true"
      - "--api.insecure=false" # disable insecure api and dashboard access
      - "--log.level=INFO"
      - "--log.format=json"
      - "--providers.docker.exposedByDefault=false"
      - "--providers.file.directory=/traefik/var"
      - "--entrypoints.http.address=:80"
      - "--entrypoints.http.http.middlewares=default-errors,default-ratelimit,default-ipallowlist-RFC1918"
      - "--entrypoints.https.address=:443"
      - "--entrypoints.https.http.middlewares=default-errors,default-ratelimit,default-ipallowlist-RFC1918"
      - "--serversTransport.insecureSkipVerify=true" # disable upstream HTTPS certificate checks (https > https)
      - "--experimental.plugins.rewriteResponseHeaders.moduleName=github.com/jamesmcroft/traefik-plugin-rewrite-response-headers"
      - "--experimental.plugins.rewriteResponseHeaders.version=v1.1.2"
      - "--experimental.plugins.geoblock.moduleName=github.com/PascalMinder/geoblock"
      - "--experimental.plugins.geoblock.version=v0.3.2"
    ports:
      - "80:80/tcp"
      - "443:443/tcp"
    volumes:
      - "var:/traefik/var"
      - "socket-proxy.run:/var/run" # access docker socket via proxy read-only
      - "plugins:/plugins-storage" # plugins stored as volume because of read-only
    networks:
      backend:
      frontend:
    sysctls:
      net.ipv4.ip_unprivileged_port_start: 80 # allow rootless container to access port 80 and higher
    restart: "always"

  nginx: # example container
    image: "11notes/nginx:stable"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nginx-example.rule=Host(`${NGINX_FQDN}`)"
      - "traefik.http.routers.nginx-example.entrypoints=https"
      - "traefik.http.routers.nginx-example.tls=true"
      - "traefik.http.routers.nginx-example.service=nginx-example"
      - "traefik.http.services.nginx-example.loadbalancer.server.port=3000"
    networks:
      backend:
    restart: "always"

volumes:
  var:
  plugins:
  socket-proxy.run:

networks:
  frontend:
  backend:
    internal: true
```

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /traefik | home directory of user docker |
| `login` | admin // traefik | login using compose example |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |

# SOURCE 💾
* [11notes/traefik](https://github.com/11notes/docker-TRAEFIK)

# PARENT IMAGE 🏛️
> [!IMPORTANT]
>This image is not based on another image but uses [scratch](https://hub.docker.com/_/scratch) as the starting layer.
>The image consists of the following distroless layers that were added:
>* [11notes/distroless](https://github.com/11notes/docker-distroless/blob/master/arch.dockerfile) - contains users, timezones and Root CA certificates
>* [11notes/distroless:curl](https://github.com/11notes/docker-distroless/blob/master/curl.dockerfile) - app to execute HTTP or UNIX requests

# BUILT WITH 🧰
* [traefik](https://github.com/traefik/traefik)

# GENERAL TIPS 📌
> [!TIP]
>* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
>* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# CAUTION ⚠️
> [!CAUTION]
>* If you use the compose example as a base for your individual configuration, please make sure to change the default dashboard login account password

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-traefik/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-traefik/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-traefik/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 27.04.2025, 21:43:56 (CET)*