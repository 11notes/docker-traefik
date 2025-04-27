ARG APP_UID=1000
ARG APP_GID=1000

# :: Util
  FROM 11notes/util AS util

# :: Build / traefik
  FROM alpine AS build
  ARG TARGETARCH
  ARG TARGETPLATFORM
  ARG TARGETVARIANT
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
    wget -O traefik.tar.gz "https://github.com/traefik/traefik/releases/download/v${APP_VERSION}/traefik_v${APP_VERSION}_linux_${TARGETARCH}${TARGETVARIANT}.tar.gz"; \
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
    # volume to store certificates and dynamic yml/tml/etc
    mkdir -p ${APP_ROOT}/var; \
    # path to store plugins as a volume if plugins are used [optional]
    mkdir -p /distroless/plugins-storage;

# :: Distroless / file system
  FROM scratch AS distroless-fs
  ARG APP_ROOT
  COPY --from=fs ${APP_ROOT} /${APP_ROOT}
  COPY --from=fs /distroless/ /


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
    COPY --from=distroless --chown=${APP_UID}:${APP_GID} / /
    COPY --from=distroless-fs --chown=${APP_UID}:${APP_GID} / /
    COPY --from=distroless-curl --chown=${APP_UID}:${APP_GID} / /
    COPY --from=distroless-traefik --chown=${APP_UID}:${APP_GID} / /

# :: Volumes
  VOLUME ["${APP_ROOT}/var"]

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD ["/usr/local/bin/curl", "-kILs", "--fail", "-o", "/dev/null", "http://localhost:8080/ping"]

# :: Start
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/usr/local/bin/traefik"]