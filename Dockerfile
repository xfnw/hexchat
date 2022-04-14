FROM alpine:edge
RUN apk add build-base cmake gtk+2.0-dev libc-utils luajit-dev meson openssl-dev pciutils-dev perl-dev py3-cffi python3-dev
RUN addgroup hexchatter \
&& adduser  -G hexchatter -s /bin/sh -D hexchatter
ADD . /hexchat
WORKDIR /hexchat
RUN meson build
WORKDIR /hexchat/build
RUN ninja install || true
WORKDIR /home/hexchatter
RUN apk del build-base cmake meson
RUN rm -rf /apk /tmp/* /var/cache/apk/* /hexchat
ADD .gtkrc-2.0 /home/hexchatter/
ADD *.conf /home/hexchatter/.config/hexchat/
RUN chown -R hexchatter:hexchatter /home/hexchatter
USER hexchatter
CMD ["hexchat"]
