
### STEP 0: Copy all the files from the repository to the root folder of your Laravel project

### STEP I: Build the Os image based on Ubuntu
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

### STEP II: Build PHP base image using STEP 1 output image as FROM image

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

## STEP III: Create final docker images

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