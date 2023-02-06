# nginx-php-fpm-ssh

## About

Nginx + PHP-FPM + SSH Docker image by [Samuraee](https://github.com/samuraee).

Compatible for Laravel concepts


All processes through this container handled by using Supervisord.
You can deploy every service by customizing supervisor config files like what you can see in container folder



## STEP 1: Build Os image based on Debian
This image included sshd, nginx and also nodejs from official apt repository

### build Ubuntu jammy/22.04 including general packages 
- Arguments (ARG):
```
- NONROOT_USER         eg, iamnotroot, nonroot, noone, ...
```
- Enviroment variables (ENV):
```
- TZ                   eg: Asia/Tehran
```

```bash
docker build --build-arg NONROOT_USER=iamnotroot \
    -f step1.Dockerfile \
    -t aboozar/ubuntu-for-laravel-os:jammy \
    -t aboozar/ubuntu-for-laravel-os:22.04 .
```

## STEP 2: Build PHP base image

- Arguments (ARG):
```
PECL_PACKAGES        eg, grpc apcu protobuf mcrypt
NODE_VERSION         eg, current, lts, 16, 18, 19
COMPOSER_VERSION     eg, -stable, --version=2.*
```

```
docker build --build-arg PECL_PACKAGES="apcu mcrypt" \
    --build-arg NODE_VERSION=current \
    --build-arg COMPOSER_VERSION="-stable" \
    -f step2.Dockerfile \
    -t aboozar/ubuntu-for-laravel-base:8.1 .
```

# Run final application container"

## Config files:
First of all, customize the following files based on your desired configs
Mandatory steps:
If you chose a NONROOT_USER except the given one (iamnotroot) change user and group in the following files
```
deployment/docker/global/nginx/nginx.conf
deployment/docker/${APP_ENV}/php/www.conf

```

```
/etc/ssh/sshd_config
/etc/nginx/nginx.conf
/etc/nginx/sites-enabled/default
# php-fpm config
/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
# php modules
/etc/php/${PHP_VERSION}/mods-available/modules.conf
/etc/supervisord.d/web-px.ini    # for web container
/etc/supervisord.d/cron-px.ini   # for cron container
/etc/supervisord.d/queue-px.ini  # for queue container
```

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.


## Sample laravel app Dockerfile (web contaner) with PHP 7.1

See `example-web.Dockerfile`
```
docker build -f app-web.Dockerfile \
    -t aboozar/laravel-app-web .
```

## Sample laravel queue Dockerfile (queue contaner) with PHP 7.1

See `example-queue.Dockerfile`

## Sample laravel cron Dockerfile (cron contaner) with PHP 7.1

See `example-cron.Dockerfile`