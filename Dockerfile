FROM alpine:latest
RUN apk add build-base cmake gtk+2.0-dev libc-utils luajit-dev meson openssl-dev pciutils-dev perl-dev py3-cffi python3-dev
ADD . /hexchat
WORKDIR /hexchat
RUN meson setup build
WORKDIR /hexchat/build
RUN ninja install || true
FROM alpine:latest
RUN apk add --no-cache gtk+2.0 pciutils-libs luajit perl py3-cffi font-jetbrains-mono-nerd
COPY --from=0 /usr/local /usr/local
RUN addgroup hexchatter \
&& adduser -G hexchatter -s /bin/sh -D hexchatter
WORKDIR /home/hexchatter
ADD .gtkrc-2.0 /home/hexchatter/
ADD *.conf /home/hexchatter/.config/hexchat/
RUN chown -R hexchatter:hexchatter /home/hexchatter
USER hexchatter
CMD ["hexchat"]
