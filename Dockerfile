FROM  tatsushid/tinycore:11.0-x86_64 AS builder

ARG NHOS_VERSION=1.1.6

WORKDIR /tmp
RUN tce-load -wic p7zip.tcz openssl-1.1.1.tcz && \
    wget https://files.nicehash.com/nhminer/nhos/nhos-${NHOS_VERSION}/image/nhos-${NHOS_VERSION}.img.gz -O nhos.img.gz && \
    gunzip nhos.img.gz && \
    7z x '-i!EFI System.img' nhos.img && rm nhos.img && \
    7z x -onhos 'EFI System.img' && rm 'EFI System.img' && \
    gunzip nhos/boot/default/initrd.gz && \
    7z x -oroot nhos/boot/default/initrd

FROM tatsushid/tinycore:11.0-x86_64

COPY --from=builder /tmp/root/usr/local/bin/nhm* /tmp/root/usr/local/bin/nhos_* /tmp/root/usr/local/bin/rig_* /usr/local/bin/
COPY --from=builder /tmp/root/opt/nhos /opt/nhos
COPY --from=builder --chown=tc:staff /tmp/nhos/apps/default /tmp/apps

RUN tce-load -wic openssl-1.1.1.tcz & \
    tce-load -ic /tmp/apps/* && \
    sudo chmod 755 /usr/local/bin/* /opt/nhos/* && \
    sudo rm -fr /tmp/apps

ENV NHOS_CONFIG_FILE=/home/tc/configuration.txt

VOLUME /home/tc
WORKDIR /home/tc

#ENTRYPOINT ["/entrypoint"]
CMD ["sh"]
