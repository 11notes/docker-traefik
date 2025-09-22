# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
  # GLOBAL
  ARG BUILD_BIN=/traefik

  # :: FOREIGN IMAGES
  FROM 11notes/distroless AS distroless
  FROM 11notes/distroless:localhealth AS distroless-localhealth
  FROM 11notes/util:bin AS util-bin

# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
# :: TRAEFIK
  FROM alpine AS build
  COPY --from=util-bin / /
  ARG TARGETPLATFORM \
      TARGETOS \
      TARGETARCH \
      TARGETVARIANT \
      APP_IMAGE \
      APP_NAME \
      APP_VERSION \
      APP_ROOT \
      APP_UID \
      APP_GID

  RUN set -ex; \
    eleven github asset traefik/traefik v${APP_VERSION} traefik_v${APP_VERSION}_linux_${TARGETARCH}${TARGETVARIANT}.tar.gz;

  RUN set- ex; \
    eleven distroless ${BUILD_BIN};

# :: FILE SYSTEM
  FROM alpine AS file-system
  ARG TARGETPLATFORM \
      TARGETOS \
      TARGETARCH \
      TARGETVARIANT \
      APP_IMAGE \
      APP_NAME \
      APP_VERSION \
      APP_ROOT \
      APP_UID \
      APP_GID

  RUN set -ex; \
    mkdir -p /distroless${APP_ROOT}/var; \
    mkdir -p /distroless${APP_ROOT}/plugins; \
    mkdir -p ${APP_ROOT}/plugins; \
    ln -sf ${APP_ROOT}/plugins /distroless/plugins-storage;


# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: HEADER
  FROM scratch

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=distroless / /
    COPY --from=distroless-localhealth / /
    COPY --from=build /distroless/ /
    COPY --from=file-system --chown=${APP_UID}:${APP_GID} /distroless/ /

# :: Volumes
  VOLUME ["${APP_ROOT}/var"]

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s --start-period=5s \
    CMD ["/usr/local/bin/localhealth", "http://127.0.0.1:8080/ping", "-I"]

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/usr/local/bin/traefik"]