FROM --platform=$BUILDPLATFORM alpine:3.15@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300 AS fetcher-base

RUN apk add -U wget ca-certificates

# renovate: datasource=github-releases depName=miguelmota/ipdr
ENV IPDR_VERSION=v0.1.7

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-arm-v6
ENV SUFFIX=linux_armv6

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-arm64-
ENV SUFFIX=linux_arm64

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-amd64-
ENV SUFFIX=linux_amd64

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-386-
ENV SUFFIX=linux_386

FROM --platform=$BUILDPLATFORM fetcher-$TARGETOS-$TARGETARCH-$TARGETVARIANT AS fetcher

RUN wget https://github.com/miguelmota/ipdr/releases/download/${IPDR_VERSION}/ipdr_${IPDR_VERSION#v}_${SUFFIX}.tar.gz
RUN tar zxvf ipdr_${IPDR_VERSION#v}_${SUFFIX}.tar.gz
RUN mv ipdr /ipdr

# distroless lacks variants?
FROM --platform=$TARGETOS/$TARGETARCH gcr.io/distroless/static@sha256:1cc74da80bbf80d89c94e0c7fe22830aa617f47643f2db73f66c8bd5bf510b25
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
