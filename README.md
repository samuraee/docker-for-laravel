# docker-for-laravel

## About

:copyright: Nonroot & Multi-Env Docker for Laravel 9+ projects by [Samuraee](https://github.com/samuraee).
:dragon_face:  Compatible with all Large scale Laravel concepts
:dragon_face:  Compatible with Gitlab CI/CD concepts
:dragon_face:  Compatible with Kubernetes concepts

# Basic assumptions
1. The entrypoint of all containers are supervisord process and the rest processes will be handle using **supervisord** facilities.
2. Everything should be customizable such as non-root username, PHP version, nodejs version, timezone, composer version, pecl packages and etc.
3. I have hold some apt packages by using `apt-mark hold` command to prevent unwanted upgrades. eg: `apt-mark hold php8.1`.
4. Each PHP version has it's own branch for example for using PHP 8.2 use git branch `php8.2`
5. You can use these dockerfiles in three different environemtn development, staging, production.
6. The PHP `xdebug` feature is enabled in the development and staging environments.

# Container(s) Architecture:
:tophat: I assumed that you will have the following docker containers in your application. It is obvious that not all of these containers are necessary for all applications.
1. **laravel-for-web** container that included nginx + fpm to handle the web part of the project
2. **laravel-for-queue** container that handles Laravel's queue workers
3. **laravel-for-cron** container that handles Laravel's schedule tasks
4. **laravel-for-socket** container that handles Laravel's websocket

:cyclone: You can handle all these features in only one docker container but I separated them to make them more maintainable for complicated applications

# Installation

### STEP 0: Copy all the files from the repository to the root folder of your Laravel project

### STEP 1: Build the Os image based on Ubuntu
This image install supervisor, nginx and also nodejs from the official apt repository

#### build Ubuntu jammy/22.04 including general packages  
- Arguments (ARG):
```
NONROOT_USER         eg, iamnotroot, nonroot, noone, ... [default: iamnotroot]
```
- Enviroment variables (ENV):
```
TZ                   eg: Europe/Berlin, Asia/Tehran, ... [default: Asia/Tehran]
```

```bash
docker build --build-arg NONROOT_USER=iamnotroot \
    -f step1.Dockerfile \
    -t aboozar/ubuntu-for-laravel-os:jammy \
    -t aboozar/ubuntu-for-laravel-os:22.04 .
```

### STEP 2: Build PHP base image using STEP 1 output image as FROM image

- Arguments (ARG):
```
PECL_PACKAGES        eg, grpc apcu protobuf mcrypt [default: apcu mcrypt]
NODE_VERSION         eg, current, lts, 16, 18, 19 [default: current]
COMPOSER_VERSION     eg, -stable, --version=2.* [default: -stable]
```

```
docker build --build-arg PECL_PACKAGES="apcu mcrypt" \
    --build-arg NODE_VERSION=current \
    --build-arg COMPOSER_VERSION="-stable" \
    -f step2.Dockerfile \
    -t aboozar/ubuntu-for-laravel-base:8.1 .
```

## Create final docker images

### Customizations:

-  :exclamation: Mandatory steps:
1. If you have chosen a NONROOT_USER different than the default (iamnotroot), change user and group in the following files before build
`
deployment/docker/{APP_ENV}/php/www.conf line: 23, 24, 48, 49
`
- :grey_exclamation: Optional steps:
1. Enable or disable your STEP 2 installed pecl modules (PECL_PACKAGES) in:
`
deployment/docker/global/php/modules.ini
`
2. Customize your `php.ini` file in: 
`deployment/docker/{APP_ENV}/php/php.ini`
2. Customize your nginx virtualhost in:
`
deployment/docker/{APP_ENV}/nginx/vhost.conf
`

### Create all-in-one application container (recommended for small projects)
See `all-in-one.Dockerfile`
```
docker build -f all-in-one.Dockerfile \
    -t aboozar/laravel-all-in-one .
```

### Create seperated application containers (recommended for mid/large projects)

#### Build laravel web Dockerfile (web container)

See `app-web.Dockerfile`
```
docker build -f app-web.Dockerfile \
    -t aboozar/laravel-app-web .
```

#### Build laravel queue Dockerfile (queue container)

See `app-queue.Dockerfile`
```
docker build -f app-queue.Dockerfile \
    -t aboozar/laravel-app-queue .
```

#### Build laravel cron Dockerfile (cron container)

See `app-cron.Dockerfile`
```
docker build -f app-cron.Dockerfile \
    -t aboozar/laravel-app-cron .
```

#### Build laravel cron Dockerfile (socket container)

See `app-socket.Dockerfile`
```
docker build -f app-socket.Dockerfile \
    -t aboozar/laravel-app-socket .
```