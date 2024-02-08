#!/bin/ash
  if [ -z "${1}" ]; then
    elevenLogJSON info "starting traefik"
    set -- "traefik" \
      --configFile="${APP_ROOT}/etc/traefik.yaml"
  fi

  exec "$@"