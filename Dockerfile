FROM alpine:3.14@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a as fetcher

RUN apk add -U wget ca-certificates

# renovate: datasource=github-releases depName=miguelmota/ipdr
ARG IPDR_VERSION=0.1.6
ARG OS=linux
ARG ARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/v${IPDR_VERSION}/ipdr_${IPDR_VERSION}_${OS}_${ARCH}.tar.gz
RUN tar zxvf ipdr_${IPDR_VERSION}_${OS}_${ARCH}.tar.gz
RUN mv ipdr /ipdr

FROM alpine:3.14@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
