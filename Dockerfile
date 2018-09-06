FROM hermsi/alpine-sshd:latest

#system
ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}
ENV ROOT_PASSWORD root

#nomal setup
RUN set -ex && \
    && apk --no-cache upgrade \
    && apk add --no-cache --virtual .build-deps ca-certificates curl tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    
#install v2ray
ENV V2RAY_LOG_DIR /var/log/v2ray
ENV V2RAY_CONFIG_DIR /etc/v2ray/
ENV V2RAY_VERSION v3.38
ENV V2RAY_DOWNLOAD_URL https://github.com/v2ray/v2ray-core/releases/download/${V2RAY_VERSION}/v2ray-linux-64.zip

curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip ${V2RAY_DOWNLOAD_URL} \
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray/ \
mv /tmp/v2ray/v2ray-${V2RAY_VERSION}-linux-64/v2ray /usr/bin \
    && mv /tmp/v2ray/v2ray-${V2RAY_VERSION}-linux-64/vpoint_vmess_freedom.json /etc/v2ray/config.json \
    && chmod +x /usr/bin/v2ray \
    && apk del curl \

#install efb

#make clean
rm -rf /tmp/v2ray /var/cache/apk/*

#make dir
    && mkdir -p /var/run/sshd \
    && mkdir -p /root/.ehforwarderbot/profiles/default/ \
    && mkdir -p /root/.ehforwarderbot/profiles/default/blueset.telegram \

#COPY config file
COPY nghttpx.conf /etc/nghttpx/nghttpx.conf
COPY squid.conf /etc/squid/squid.conf
COPY blueset.telegram-config.yaml /root/.ehforwarderbot/profiles/default/bluestet.telegram\config.yaml
COPY default-config.yaml /root/.ehforwarderbot/profiles/default/config.yaml
COPY v2rayconfig.json /etc/v2ray/config.json
COPY entrypoint.sh /usr/local/bin/

#ss
ENV SS_PORT=8888
ENV SS_PASSWORD=wnxd
ENV SS_METHOD=aes-256-gcm

#vmess
ENV VMESS_PORT=9999
ENV VMESS_ID=00000000-0000-0000-0000-000000000000
ENV VMESS_LEVEL=1
ENV VMESS_ALTERID=64

#kcp
ENV KCP_PORT_VMESS=9999
ENV KCP_MUT=1350
ENV KCP_TTI=50
ENV KCP_UPLINK=5
ENV KCP_DOWNLINK=20
ENV KCP_READBUFF=2
ENV KCP_WRITEBUFF=2

#EFB
ENV TOKEN=88888888:00000000000000000
ENV ADM=999999999

EXPOSE ${SS_PORT}/tcp
EXPOSE ${SS_PORT}/udp
EXPOSE ${VMESS_PORT}/tcp
EXPOSE ${KCP_PORT_VMESS}/udp

ENTRYPOINT [ "bash", "/usr/bin/entrypoint.sh" ]
