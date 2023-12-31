FROM --platform=linux/amd64 golang:latest AS V2RAY-PLUGIN-BUILD
RUN apt install git && \
    git clone https://github.com/shadowsocks/v2ray-plugin.git /v2ray-plugin
WORKDIR /v2ray-plugin
RUN go build 

FROM ghcr.io/shadowsocks/ssserver-rust:latest
COPY --from=V2RAY-PLUGIN-BUILD --chmod=777 /v2ray-plugin/v2ray-plugin /usr/bin/v2ray-plugin
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "ssserver", "--log-without-time", "-c", "/etc/shadowsocks-rust/config.json" ]