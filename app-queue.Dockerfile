# You can use version 7.1, 7.2, 7.3, 7.4
ARG PHP_VERSION

FROM aboozar/nginx-php-base:$PHP_VERSION

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="My aravel queue container"
LABEL Version="20210921"
LABEL TargetImageName="aboozar/my-laravel-queue"

# [Optional] Set the default/non-root user. Omit if you want to keep the default as root.
USER nonroot

# Configure custom things

COPY ssh/sshd_config /etc/ssh/sshd_config

# add any customization you need
COPY php/modules.ini /etc/php/${PHP_VERSION}/mods-available/modules.ini

# specify container's processes
COPY container/queue-px.conf /etc/supervisor/conf.d/queue-px.conf

# Copy all stuffs
COPY --chown=${NONROOT_USER}:${NONROOT_USER} . /var/www/

RUN if [ "${APP_ENV}" != "local" ] ; \
    then  \
    composer install --no-dev --optimize-autoloader; \
    fi

WORKDIR /var/www/
