# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Header
  FROM 11notes/express:stable
  COPY --from=util /util/node/util.js /node
  ENV EXPRESS_ERROR_TITLE="Traefik Loadbalancer "

# :: Run
  USER root

# :: copy root filesystem changes and set correct permissions
  COPY ./error ${APP_ROOT}

  RUN set -ex; \
    chown -R 1000:1000 \
    ${APP_ROOT}

# :: Start
  USER docker