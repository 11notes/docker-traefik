# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Header
  FROM --platform=linux/arm64 11notes/express:stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
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