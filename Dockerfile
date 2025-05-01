ARG POSTGRES_VERSION=latest

FROM golang:1-bookworm AS build

ARG WALG_VERSION=master

RUN apt-get update && apt-get install -qqy --no-install-recommends --no-install-suggests cmake gnutls-bin liblzo2-dev libsodium23 libsodium-dev && \
    cd /go/src/ && \
    git clone -b $WALG_VERSION --recurse-submodules https://github.com/wal-g/wal-g.git && \
    cd wal-g && \
    GOBIN=/go/bin go mod tidy && \
    GOBIN=/go/bin USE_LIBSODIUM=1 USE_LZO=1 make install_and_build_pg

FROM postgres:$POSTGRES_VERSION

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -qqy curl ca-certificates libsodium23 vim

COPY --from=build /go/src/wal-g/main/pg/wal-g /usr/local/bin/wal-g

COPY wal-g /wal-g

LABEL maintainer="Bruno Paz <oss@brunopaz.dev" \
    org.opencontainers.image.authors="Bruno Paz <oss@brunopaz.dev>" \
    org.opencontainers.image.source="https://github.com/brpaz/docker-postgres-wal-g"
