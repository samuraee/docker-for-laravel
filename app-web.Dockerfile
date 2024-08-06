FROM samuraee/ubuntu-for-laravel-base:8.3

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Laravel app - web container"
LABEL Version="8.3.x-1"
LABEL TargetImageName="aboozar/laravel-app-web"

ARG NONROOT_USER=samuraee
ARG APP_ENV=production
ENV APP_ENV=$APP_ENV

# [Optional] Set the default/non-root user. Omit if you want to keep the default as root.
USER ${NONROOT_USER}

# nginx configs
COPY deployment/docker/global/nginx/nginx.conf /etc/nginx/nginx.conf
COPY deployment/docker/${APP_ENV}/nginx/vhost.conf /etc/nginx/sites-enabled/default

# add any PHP customization you need
COPY deployment/docker/global/php/php-fpm.conf /etc/php/8.3/fpm/php-fpm.conf
COPY deployment/docker/global/php/modules.ini /etc/php/8.3/fpm/conf.d/10-modules.ini
COPY deployment/docker/global/php/modules.ini /etc/php/8.3/cli/conf.d/10-modules.ini
# env-based PHP config files
COPY deployment/docker/${APP_ENV}/php/www.conf /etc/php/8.3/fpm/pool.d/www.conf
COPY deployment/docker/${APP_ENV}/php/php.ini /etc/php/8.3/fpm/php.ini
COPY deployment/docker/${APP_ENV}/php/php.ini /etc/php/8.3/cli/php.ini

# main supervisord config   
COPY deployment/docker/global/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# specify container's processes
COPY deployment/docker/container/web-ps.conf /etc/supervisor/conf.d/web-ps.conf

# Copy all stuffs
COPY --chown=${NONROOT_USER}:${NONROOT_USER} . /var/www/

RUN if [ "${APP_ENV}" != "local" ] ; \
    then  \
    composer install --no-dev --optimize-autoloader; \
    fi

EXPOSE  8080

WORKDIR /var/www/
