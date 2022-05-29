FROM composer AS builder

WORKDIR /app

COPY . .

RUN composer update

FROM php:8-apache

LABEL maintainer="Zain Ul Abideen zainulabideen1258@gmail.com"

WORKDIR /srv/app

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip4 \
    libz-dev \
    libzip-dev \
    zip \
    unzip \
    locales \
    jpegoptim optipng pngquant gifsicle \
    curl \
    git \
    dos2unix \
    libonig-dev \
    libxml2-dev \
    && pecl install xdebug-3.1.3 zlib zip\
    && docker-php-ext-enable xdebug \
    && a2enmod rewrite negotiation \
    && docker-php-ext-install mbstring pdo pdo_mysql opcache soap \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY --from=builder --chown=www-data:www-data /app .
COPY apache/vhost.conf /etc/apache2/sites-available/000-default.conf

ENTRYPOINT /bin/bash entrypoints/entrypoint.sh
