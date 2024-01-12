# Alpine :: Traefik
![size](https://img.shields.io/docker/image-size/11notes/traefik/2.10.7?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/traefik?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/traefik?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-traefik?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-traefik?color=c91cb8)

Run Traefik based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Description
With this image you can run Traefik as a reverse proxy for all your web applications, TCP applications and UDP applications easily. The default configuration will use the docker provider and any dynamic configuration located in `/traefik/var`. It will also by default redirect any http traffic to https.

## Volumes
* **/traefik/etc** - Directory of traefik configuration (traefik.yaml)
* **/traefik/var** - Directory of traefik dynamic files (configs, ssl certificates)

## Run
```shell
docker run --name traefik \
  --network host \
  -v .../docker.sock:/var/run/docker.sock \
  -v .../var:/traefik/var \
  -d 11notes/traefik:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /traefik | home directory of user docker |
| `api` | https://${IP}:8080 | default |
| `config` | /traefik/etc/traefik.yaml | default configuration file |

## Environment
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | null |

## Parent image
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

## Built with (thanks to)
* [Traefik](https://traefik.io/traefik)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use rootless container runtime (podman, rootless docker)
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=80" > /etc/sysctl.d/traefik.conf` for using :80 and :443