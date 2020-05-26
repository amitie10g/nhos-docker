FROM alpine:3.11
COPY entrypoint /entrypoint
RUN apk add --no-cache qemu-img sgdisk && \
    chmod 755 /entrypoint
VOLUME /root
WORKDIR /root
ENV NHOS_VERSION=1.1.6
ENTRYPOINT ["/entrypoint"]
