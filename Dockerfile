FROM --platform=$BUILDPLATFORM alpine:3.16@sha256:b95359c2505145f16c6aa384f9cc74eeff78eb36d308ca4fd902eeeb0a0b161b AS fetcher-base

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
FROM --platform=$TARGETOS/$TARGETARCH gcr.io/distroless/static@sha256:fc8cbb80b6a489b662c0a208caaef5c10b2094d07291029337fe9010380b4aac
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
