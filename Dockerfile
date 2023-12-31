FROM --platform=linux/amd64 alpine:latest AS V2RAY-PLUGIN-DOWNLOAD
RUN cd /tmp && \
    TAG=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$TAG/v2ray-plugin-linux-amd64-$TAG.tar.gz && \
    tar -xf *.gz && \
    rm *.gz && \
    mv v2ray* /usr/bin/v2ray-plugin

FROM ghcr.io/shadowsocks/ssserver-rust:latest
COPY --from=V2RAY-PLUGIN-DOWNLOAD /usr/bin/v2ray-plugin /usr/bin/v2ray-plugin
RUN chmod +x /usr/bin/v2ray-plugin
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "ssserver", "--log-without-time", "-c", "/etc/shadowsocks-rust/config.json" ]