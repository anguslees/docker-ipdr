FROM alpine:3.9@sha256:414e0518bb9228d35e4cd5165567fb91d26c6a214e9c95899e1e056fcd349011 as fetcher

RUN apk add -U wget ca-certificates

ARG VERSION=0.1.6
ARG OS=linux
ARG ARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/v$VERSION/ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN tar zxvf ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN mv ipdr /ipdr

FROM alpine:3.9@sha256:414e0518bb9228d35e4cd5165567fb91d26c6a214e9c95899e1e056fcd349011
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
