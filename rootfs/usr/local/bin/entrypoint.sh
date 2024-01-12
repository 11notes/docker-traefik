#!/bin/ash
  if [ -z "${1}" ]; then
    log-json info "starting traefik with default configuration"
    set -- "traefik" \
      --configFile="${APP_ROOT}/etc/traefik.yaml"
  fi

  exec "$@"