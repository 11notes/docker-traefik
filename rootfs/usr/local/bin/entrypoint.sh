#!/bin/ash
  set -ex

  if [ -z "${1}" ]; then
    elevenLogJSON info "starting traefik with [${APP_ROOT}/etc/default.yaml]"
    set -- traefik \
      --configFile="${APP_ROOT}/etc/default.yaml"
  else
    elevenLogJSON info "starting traefik with command line parameters"
    set -- traefik "$@"
  fi

  exec "$@"