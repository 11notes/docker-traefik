#!/bin/ash
  if [ -z "$1" ]; then
    set -- "traefik" \
      --configFile="${APP_ROOT}/etc/traefik.yaml"
  fi

  exec "$@"