# Alpine :: Traefik
Run Traefik based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Volumes
* **/traefik/etc** - Directory of traefik configuration (traefik.yaml)

## Run
```shell
docker run --name traefik \
  -p 8080:8080 \
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

## Parent
* [11notes/alpine:stable](https://github.com/11notes/docker-alpine)

## Built with
* [traefik](https://traefik.io/traefik)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Don't run in docker, use podman or rootless docker
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy