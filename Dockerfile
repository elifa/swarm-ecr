FROM alpine:latest

WORKDIR /opt

RUN apk add --no-cache dcron ca-certificates python python2-dev py-setuptools && \
    chmod go+x /usr/sbin/crond && \
    if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi && \
    if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi && \
    if [[ ! -e /usr/bin/easy_install ]]; then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi && \
    easy_install pip && \
    pip install --upgrade pip && \
    addgroup -S -g 50 docker && \
    adduser -D -S -u 1001 -G docker docker && \
    addgroup docker cron

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.sh ./
COPY ecr-update.sh ./
COPY swarm-update.sh ./

RUN rm -rf /var/spool/cron/crontabs && \
    mkdir -m 0755 -p /var/spool/cron/crontabs && \
    chown -R 1001:50 /var/spool/cron && \
    mkdir -p /var/log/cron && \
    chown 1001:50 /var/log/cron && \
    chown 1001:50 /opt/*.sh && \
    chmod +x /opt/*.sh

ENV REGION="eu-west-1"

USER docker
VOLUME /home/docker

ENTRYPOINT ./entrypoint.sh