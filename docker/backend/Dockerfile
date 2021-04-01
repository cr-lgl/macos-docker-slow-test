#
# PHP Setup
#

FROM php:8.0.3-apache-buster

#
# Install dependencies
#

RUN set -xe; \
    apt-get update && \
    apt-get install -y \
        curl \
        zip \
        zlib1g-dev \
        libzip-dev \
        libicu-dev && \
    pecl install \
        xdebug && \
    docker-php-ext-install \
        zip \
        intl && \
    docker-php-ext-enable \
        xdebug && \
    echo "xdebug.xdebug.mode=debug,gcstats,trace" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           /var/log/lastlog \
           /var/log/faillog

#
# Workspace User
#

ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN set -xe; \
    groupadd -f workspace && \
    groupmod -g ${APP_GROUP_ID} workspace && \
    useradd workspace -g workspace && \
    mkdir -p /home/workspace && chmod 755 /home/workspace && chown workspace:workspace /home/workspace && \
    usermod -u ${APP_USER_ID} -m -d /home/workspace workspace -s $(which bash) && \
    chown -R workspace:workspace /var/www/html

#
# Set Timezone
#

ARG TIME_ZONE='Asia/Seoul'

RUN ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo ${TIME_ZONE} > /etc/timezone

#
# Composer Setup
#

ARG COMPOSER_VERSION=2.0.9
ARG COMPOSER_REPO_PACKAGIST='https://packagist.jp'

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} && \
    composer config -g repos.packagist composer ${COMPOSER_REPO_PACKAGIST}


#
# Set Apache
#
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite

WORKDIR /var/www/html
