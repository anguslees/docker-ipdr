FROM --platform=$BUILDPLATFORM alpine:3.22@sha256:310c62b5e7ca5b08167e4384c68db0fd2905dd9c7493756d356e893909057601 AS fetcher-base

RUN apk add -U wget ca-certificates

# renovate: datasource=github-releases depName=miguelmota/ipdr
ENV IPDR_VERSION=v0.1.7

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-arm-v6-x
ENV SUFFIX=linux_armv6

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-arm64--x
ENV SUFFIX=linux_arm64

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-amd64--x
ENV SUFFIX=linux_amd64

FROM --platform=$BUILDPLATFORM fetcher-base AS fetcher-linux-386--x
ENV SUFFIX=linux_386

FROM --platform=$BUILDPLATFORM fetcher-$TARGETOS-$TARGETARCH-$TARGETVARIANT-x AS fetcher

RUN wget https://github.com/miguelmota/ipdr/releases/download/${IPDR_VERSION}/ipdr_${IPDR_VERSION#v}_${SUFFIX}.tar.gz
RUN tar zxvf ipdr_${IPDR_VERSION#v}_${SUFFIX}.tar.gz
RUN mv ipdr /ipdr

# distroless lacks variants?
FROM --platform=$TARGETOS/$TARGETARCH gcr.io/distroless/static@sha256:3592aa8171c77482f62bbc4164e6a2d141c6122554ace66e5cc910cadb961ff0
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
