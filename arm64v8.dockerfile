# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;


# :: Build
  FROM arm64v8/alpine as build
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  ENV APP_VERSION=v2.10.7

  USER root

  ADD https://github.com/traefik/traefik/releases/download/${APP_VERSION}/traefik_${APP_VERSION}_linux_amd64.tar.gz /tmp
  RUN set -ex; \
    apk --no-cache add \
      tar; \
    cd /tmp; \
    tar -xzvf traefik_${APP_VERSION}_linux_amd64.tar.gz traefik; \
    mv traefik /usr/local/bin;

# :: Header
  FROM 11notes/alpine:arm64v8-stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  COPY --from=build /usr/local/bin/ /usr/local/bin
  ENV APP_NAME="traefik"
  ENV APP_ROOT=/traefik

# :: Run
  USER root

  # :: prepare image
    RUN set -ex; \
      mkdir -p ${APP_ROOT}/etc; \
      apk --no-cache upgrade;

  # :: set home directory for existing docker user
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker;

  # :: copy root filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R 1000:1000 \
      ${APP_ROOT}

# :: Volumes
  VOLUME ["${APP_ROOT}/etc", "${APP_ROOT}/var"]

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]