# :: Util
  FROM 11notes/util AS util

# :: Build / traefik
  FROM alpine AS build
  ARG TARGETARCH
  ARG APP_VERSION
  ENV BUILD_BIN=/traefik

  USER root

  COPY --from=util /usr/local/bin/ /usr/local/bin

  RUN set -ex; \
    apk --update --no-cache add \
      wget \
      tar \
      build-base \
      upx;

  RUN set -ex; \
    mkdir -p /distroless/usr/local/bin; \
    wget -O traefik.tar.gz https://github.com/traefik/traefik/releases/download/v${APP_VERSION}/traefik_v${APP_VERSION}_linux_${TARGETARCH}.tar.gz; \
    tar -xzvf traefik.tar.gz; \
    eleven strip ${BUILD_BIN}; \
    cp ${BUILD_BIN} /distroless/usr/local/bin;

# :: Distroless / traefik
  FROM scratch AS distroless-traefik
  ARG APP_ROOT
  COPY --from=build /distroless/ /


# :: Build / file system
  FROM alpine AS fs
  ARG APP_ROOT
  USER root

  RUN set -ex; \
    mkdir -p ${APP_ROOT}/var;

# :: Distroless / file system
  FROM scratch AS distroless-fs
  ARG APP_ROOT
  COPY --from=fs ${APP_ROOT} /${APP_ROOT}


# :: Header
  FROM 11notes/distroless AS distroless
  FROM 11notes/distroless:curl AS distroless-curl
  FROM scratch

  # :: arguments
    ARG TARGETARCH
    ARG APP_IMAGE
    ARG APP_NAME
    ARG APP_VERSION
    ARG APP_ROOT
    ARG APP_UID
    ARG APP_GID

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE}
    ENV APP_NAME=${APP_NAME}
    ENV APP_VERSION=${APP_VERSION}
    ENV APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=distroless --chown=1000:1000 / /
    COPY --from=distroless-fs --chown=1000:1000 / /
    COPY --from=distroless-curl --chown=1000:1000 / /
    COPY --from=distroless-traefik --chown=1000:1000 / /

# :: Volumes
  VOLUME ["${APP_ROOT}/var"]

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD ["/usr/local/bin/curl", "-kILs", "--fail", "-o", "/dev/null", "http://localhost:8080/ping"]

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/traefik"]