FROM --platform=linux/amd64 golang:latest AS V2RAY-PLUGIN-BUILD
RUN apt install git && \
    git --version
RUN git clone https://github.com/shadowsocks/v2ray-plugin.git /v2ray-plugin
WORKDIR /v2ray-plugin
RUN go build 

FROM --platform=linux/amd64 ghcr.io/shadowsocks/ssserver-rust:latest
COPY --from=V2RAY-PLUGIN-BUILD /v2ray-plugin/v2ray-plugin /v2ray-plugin
CMD ["ssserver", "-c /etc/shadowsocks-rust/config.json"]