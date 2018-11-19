FROM alpine:3.8
LABEL maintainer="Ycarus (Yannick Chabanois) <ycarus@zugaina.org>"

RUN apk add --no-cache openvpn
ADD openvpn.sh /usr/sbin/openvpn.sh

VOLUME ["/etc/openvpn"]

CMD exec /usr/sbin/openvpn.sh
