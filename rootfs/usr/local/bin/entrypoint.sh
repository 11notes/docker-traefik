#!/bin/ash
  if [ -z "$1" ]; then
    TRAEFIK_CONFIG="${APP_ROOT}/etc/traefik.yaml"
    if [ -f "${TRAEFIK_CONFIG}" ]; then
      set -- "traefik" \
        --configFile="${TRAEFIK_CONFIG}"
    else
      echo "${TRAEFIK_CONFIG} is missing, abort."
      exit 1
    fi
  fi

  exec "$@"