FROM wnxd/docker-v2ray

#system
ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}
ENV ROOT_PASSWORD=root
ENV HTTP_USER=sakuya

#EFB
ENV TOKEN=88888888:00000000000000000
ENV ADM=999999999

#nomal setup
RUN set -ex \
    && apk --no-cache upgrade \
    && apk add --no-cache --virtual .build-deps ca-certificates tzdata ffmpeg \
    libmagic python3 py3-numpy py3-pillow libwebp py3-yaml py3-requests python-dev gcc\
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone 
    
    #install efb
RUN set -ex \
    && pip3 install --upgrade pip \
    && pip3 install ehforwarderbot \
    && pip3 install efb-telegram-master \
    && pip3 install efb-wechat-slave \
    && mkdir -p /var/run/sshd \
    && mkdir -p /root/.ehforwarderbot/profiles/default/ \
    && mkdir -p /root/.ehforwarderbot/profiles/default/blueset.telegram 
    
#make clean
#    && rm -rf /tmp/v2ray /var/cache/apk/*
    
COPY nghttpx.conf /etc/nghttpx/nghttpx.conf
COPY squid.conf /etc/squid/squid.conf
COPY blueset.telegram-config.yaml /root/.ehforwarderbot/profiles/default/bluestet.telegram\config.yaml
COPY default-config.yaml /root/.ehforwarderbot/profiles/default/config.yaml
COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "bash", "/usr/bin/entrypoint.sh" ]
