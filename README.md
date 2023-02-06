# docker-for-laravel

## About

- :copyright: Nonroot & Multi-Env Docker for Laravel 9+ projects by [Samuraee](https://github.com/samuraee).
- :dragon_face: Compatible with all Large scale Laravel concepts
- :dragon_face: Compatible with Gitlab CI/CD concepts
- :dragon_face: Compatible with Kubernetes concepts

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

:cyclone: You can handle all these features in only one docker container but I have separated 
them to make them more maintainable for complicated applications.

# Installation:
- :fish: [basic usage](https://github.com/samuraee/docker-for-laravel/blob/master/BASIC_USAGE.md)
- :whale2: [Advanced usage](https://github.com/samuraee/docker-for-laravel/blob/master/PRO_USAGE.md)