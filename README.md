# Alpine :: Traefik
![size](https://img.shields.io/docker/image-size/11notes/traefik/2.10.5?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/traefik?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/traefik?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-traefik?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-traefik?color=c91cb8)

Run Traefik based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Volumes
* **/traefik/etc** - Directory of traefik configuration (traefik.yaml)
* **/traefik/var** - Directory of traefik dynamic files

## Run
```shell
docker run --name traefik \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  -v /run/docker.sock:/var/run/docker.sock \
  -v ../etc:/traefik/etc \
  -d 11notes/traefik:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /traefik | home directory of user docker |
| `web` | http://${IP}:8080 | default web ui |
| `config` | /traefik/etc/traefik.yaml | default configuration file |
| `provider` | docker && /traefik/var  | default providers |

## Parent
* [11notes/alpine:stable](https://github.com/11notes/docker-alpine)

## Built with
* [Traefik](https://traefik.io/traefik)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use rootless container runtime (podman, rootless docker)