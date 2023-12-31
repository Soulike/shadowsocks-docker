FROM --platform=linux/amd64 golang:latest AS V2RAY-PLUGIN-BUILD
RUN apt install git && \
    git clone https://github.com/shadowsocks/v2ray-plugin.git /v2ray-plugin
WORKDIR /v2ray-plugin
RUN go build 

FROM --platform=linux/amd64 rust:latest AS SS-BUILD
RUN apt install git && \
    git clone https://github.com/shadowsocks/shadowsocks-rust.git /shadowsocks-rust
WORKDIR /shadowsocks-rust
RUN cargo build --release

FROM --platform=linux/amd64 alpine:latest
COPY --from=V2RAY-PLUGIN-BUILD --chmod=777 /v2ray-plugin/v2ray-plugin /shadowsocks/v2ray-plugin
COPY --from=SS-BUILD --chmod=777 /shadowsocks-rust/target/release/ssserver /shadowsocks/ssserver
ENV PATH=/shadowsocks:$PATH
CMD [ "ssserver", "-c", "/etc/shadowsocks-rust/config.json" ]