FROM --platform=$BUILDPLATFORM alpine:3.19@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 AS fetcher-base

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
FROM --platform=$TARGETOS/$TARGETARCH gcr.io/distroless/static@sha256:9be3fcc6abeaf985b5ecce59451acbcbb15e7be39472320c538d0d55a0834edc
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
