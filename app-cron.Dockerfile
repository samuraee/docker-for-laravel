FROM samuraee/ubuntu-for-laravel-base:8.3

LABEL Maintainer="Aboozar Ghaffari <aboozar.ghf@gmail.com>"
LABEL Name="Laravel schedule container"
LABEL Version="8.3.x-1"
LABEL TargetImageName="aboozar/laravel-schedule"

ARG NONROOT_USER=samuraee

# Configure custom things
COPY deploy/app/ssh/sshd_config /etc/ssh/sshd_config

# add any customization you need
COPY deploy/app/php/modules.ini /etc/php/8.3/mods-available/modules.ini

# specify container's processes
COPY deploy/app/container/cron-px.conf /etc/supervisor/conf.d/cron-px.conf

RUN echo "* * * * * php /var/www/artisan schedule:run > /tmp/cron-log" >> /etc/cron.d/app-cron \
    # Give the necessary rights to the user to run the cron
    && crontab -u ${NONROOT_USER} /etc/cron.d/app-cron \
    && chmod gu+s /usr/sbin/cron

WORKDIR /var/www/

# [Optional] Set the default/non-root user. Omit if you want to keep the default as root.
USER $NONROOT_USER