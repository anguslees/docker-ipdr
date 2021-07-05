FROM alpine:3.14@sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0 as fetcher

RUN apk add -U wget ca-certificates

ARG VERSION=0.1.6
ARG OS=linux
ARG ARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/v$VERSION/ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN tar zxvf ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN mv ipdr /ipdr

FROM alpine:3.14@sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
