# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG RELURL=https://releases.hashicorp.com
ARG SRCARCH
ARG VERSION
#
ENV \
    VAULT_HOME=/vault \
    VAULT_ROLE=server
#
RUN set -ex \
    && apk add -Uu --no-cache \
        ca-certificates \
        curl \
        libcap \
        tzdata \
    && (if [ ! -e /etc/nsswitch.conf ]; then echo 'hosts: files dns' > /etc/nsswitch.conf; fi) \
    && mkdir -p /tmp/vault \
    && cd /tmp/vault \
#
    && echo "Using vault: $SRCARCH $VERSION" \
    && curl \
        -o vault_${VERSION}_${SRCARCH}.zip \
        -SL ${RELURL}/vault/${VERSION}/vault_${VERSION}_${SRCARCH}.zip \
    && curl \
        -o vault_${VERSION}_SHA256SUMS \
        -SL ${RELURL}/vault/${VERSION}/vault_${VERSION}_SHA256SUMS \
#
    # fix old sha256sum single vs double spacing issue for alpine, newer version does not care about space
    # && sed -ie 's/ /  /' vault_${VERSION}_SHA256SUMS \
    && grep vault_${VERSION}_${SRCARCH}.zip vault_${VERSION}_SHA256SUMS \
        | sha256sum -c \
#
    && unzip -d /tmp/vault vault_${VERSION}_${SRCARCH}.zip \
    && mv vault /usr/local/bin/vault \
    && chmod +x /usr/local/bin/vault \
#
    && apk del --purge \
        curl \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
VOLUME ${VAULT_HOME}
#
EXPOSE 8200 8201
#
HEALTHCHECK \
    --interval=2m \
    --retries=5 \
    --start-period=5m \
    --timeout=10s \
    CMD \
    wget --quiet --tries=1 --no-check-certificate --spider ${HEALTHCHECK_URL:-"http://localhost:8200/"} || exit 1
#
ENTRYPOINT ["/init"]
