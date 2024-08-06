FROM ubuntu:24.04

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="STEP 1: Ubuntu noble/24.04 version including general apt packages"
LABEL Version="8.3.x-1"
LABEL TargetImageName="samuraee/ubuntu-for-laravel-os:24.04"

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ "Asia/Tehran"

RUN apt update \
    && apt-get install -yq --no-install-recommends \
        apt-transport-https \
        autoconf \
        ca-certificates \
        curl \
        cron \
        g++ \
        gnupg2 \
        libmcrypt-dev \
        lsb-release \
        make \
        nginx \
        npm \
        sudo \
        supervisor \
        tmux \
        tzdata \
        wget \
        zlib1g-dev \
    && apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \ 
    && dpkg-reconfigure -f noninteractive tzdata

# give permission to required path to the generated non-root
RUN mkdir -p /var/cache/nginx/ \
    && mkdir -p /var/www/public/ \
    && chown $NONROOT_USER:$NONROOT_USER /run/ -R \
    && chown $NONROOT_USER:$NONROOT_USER /var/ -R \
    && echo '<?php phpinfo(); ?>' > /var/www/public/index.php

#expose supervisord http server port
EXPOSE  9001

# default entrypoint
CMD [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]