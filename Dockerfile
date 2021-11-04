FROM --platform=$BUILDPLATFORM alpine:3.14@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a as fetcher

RUN apk add -U wget ca-certificates

# renovate: datasource=github-releases depName=miguelmota/ipdr
ARG IPDR_VERSION=v0.1.7
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/${IPDR_VERSION}/ipdr_${IPDR_VERSION#v}_${TARGETOS}_${TARGETARCH}.tar.gz
RUN tar zxvf ipdr_${IPDR_VERSION#v}_${TARGETOS}_${TARGETARCH}.tar.gz
RUN mv ipdr /ipdr

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static@sha256:1cc74da80bbf80d89c94e0c7fe22830aa617f47643f2db73f66c8bd5bf510b25
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
