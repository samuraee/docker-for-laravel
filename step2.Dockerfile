FROM aboozar/ubuntu-for-laravel-os:22.04

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="STEP 2: Ubuntu for laravel Docherfile including Nginx, PHP-FPM, NodeJs"
LABEL Version="20230202"
LABEL TargetImageName="aboozar/ubuntu-for-laravel-base:8.1"

ARG DEBIAN_FRONTEND="noninteractive"
# pecl packages to install eg: "grpc apcu protobuf mcrypt"
ARG PECL_PACKAGES="apcu mcrypt"
# required nodejs version like 18, 19, lts, current
ARG NODE_VERSION="current"
# composer version -stable, --version=2.1.6, --version=2.*
ARG COMPOSER_VERSION="-stable"

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -

RUN apt update && apt install -yq --no-install-recommends \
        php \
        php-bcmath \
        php-cli \
        php-curl \
        php-dev \
        php-common \
        php-fpm \
        php-gd \
        php-gmp \
        php-intl \
        php-json \
        php-mbstring \
        php-mysqlnd \
        php-opcache \
        php-pdo \
        php-pgsql \
        php-soap \
        php-redis \
        php-xml \
        php-xmlwriter \
        php-xmlrpc \
        php-zip \
        php-pear \
    && apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    #freeze PHP version to v8.1 
    && apt-mark hold php8.1

RUN pecl channel-update pecl.php.net \
    && pecl install ${PECL_PACKAGES}

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin ${COMPOSER_VERSION} --filename=composer

RUN apt clean \
    && apt autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*