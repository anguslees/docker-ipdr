FROM alpine:3.9 as fetcher

RUN apk add -U wget ca-certificates

ARG VERSION=0.1.5
ARG OS=linux
ARG ARCH=amd64

RUN wget https://github.com/miguelmota/ipdr/releases/download/v$VERSION/ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN tar zxvf ipdr_${VERSION}_${OS}_${ARCH}.tar.gz
RUN mv ipdr /ipdr

FROM alpine:3.9
COPY --from=fetcher /ipdr /usr/bin/ipdr
ENTRYPOINT ["ipdr"]
