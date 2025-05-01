FROM --platform=${BUILDPLATFORM} alpine:3.19

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILD_DATE
ARG REVISION
ARG VERSION

RUN apk add --no-cache git && git --version

CMD ["sleep", "infinity"]

LABEL org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.authors="Bruno Paz" \
    org.opencontainers.image.description="Docker image template" \
    org.opencontainers.image.url="replace-me" \
    org.opencontainers.image.revision=$REVISION \
    org.opencontainers.image.version=$VERSION
