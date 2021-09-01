FROM alpine:3.14@sha256:adab3844f497ab9171f070d4cae4114b5aec565ac772e2f2579405b78be67c96 as fetcher

RUN apk add -U wget ca-certificates

# renovate: datasource=github-releases depName=miguelmota/ipdr
ARG IPDR_VERSION=0.1.6
ARG OS=linux
ARG ARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/v${IPDR_VERSION}/ipdr_${IPDR_VERSION}_${OS}_${ARCH}.tar.gz
RUN tar zxvf ipdr_${IPDR_VERSION}_${OS}_${ARCH}.tar.gz
RUN mv ipdr /ipdr

FROM alpine:3.14@sha256:adab3844f497ab9171f070d4cae4114b5aec565ac772e2f2579405b78be67c96
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
