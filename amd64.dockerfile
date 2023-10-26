# :: Build
  FROM alpine AS build
  ENV APP_VERSION=v2.10.5

  USER root

  ADD https://github.com/traefik/traefik/releases/download/${APP_VERSION}/traefik_${APP_VERSION}_linux_amd64.tar.gz /tmp
  RUN set -ex; \
    apk --no-cache add tar; \
    cd /tmp; \
    tar -xzvf traefik_${APP_VERSION}_linux_amd64.tar.gz traefik; \
    mv traefik /usr/local/bin;

# :: Header
	FROM 11notes/alpine:stable
  ENV APP_ROOT=/traefik
  COPY --from=build /usr/local/bin/ /usr/local/bin

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
	VOLUME ["${APP_ROOT}/etc"]

# :: Start
	USER docker
	ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]