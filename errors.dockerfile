ARG APP_VERSION=stable

# :: Header
  FROM 11notes/express:${APP_VERSION}

  # :: arguments  
    ENV EXPRESS_ERROR_TITLE="Traefik"

  # :: multi-stage
    COPY ./rootfs/errors /express/var

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD ["/usr/local/bin/curl", "-kILs", "--fail", "-o", "/dev/null", "http://localhost:8080/ping"]