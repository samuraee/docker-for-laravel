FROM ubuntu:22.04

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="STEP 1: Ubuntu jammy/22.04 version including general apt pckages"
LABEL Version="20230202"
LABEL TargetImageName="aboozar/ubuntu-for-laravel-os:22.04"

ARG DEBIAN_FRONTEND="noninteractive"
ARG NONROOT_USER=iamnotroot
ARG USER_UID=1000
ARG USER_GID=$USER_UID
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
        tzdata \
        wget \
        zlib1g-dev \
    && apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \ 
    && dpkg-reconfigure -f noninteractive tzdata

# Create the non-root user
RUN groupadd --gid $USER_GID $NONROOT_USER \
    && useradd --uid $USER_UID --gid $USER_GID -m $NONROOT_USER \
    && echo $NONROOT_USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$NONROOT_USER \
    && chmod 0440 /etc/sudoers.d/$NONROOT_USER

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