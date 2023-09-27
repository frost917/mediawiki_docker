# ARG MEDIAWIKI_VER=1.38.4
# ARG WIKITYPE=mediawiki
# ARG REGISTRY=docker.io

# FROM ${REGISTRY}/mediawiki:source-${MEDIAWIKI_VER} AS source

FROM php:8.1.11-fpm-alpine

ARG MEDIAWIKI_VER=1.38.4
ARG WIKITYPE=mediawiki
ARG REGISTRY=docker.io

RUN deluser www-data && addgroup -g 101 -S www-data \ 
    && adduser -S -D -H -u 101 -s /sbin/nologin www-data

RUN apk update \
    && apk add --no-cache diffutils python3 imagemagick

ADD https://curl.haxx.se/ca/cacert.pem /
RUN chmod +r /cacert.pem 

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd mysqli bcmath apcu bz2 intl redis @composer 

RUN ln -s /config/php.ini-production /usr/local/etc/php/php.ini

# COPY --chown=101:101 --from=source /var/www/mediawiki /var/www/${WIKITYPE}

USER www-data

CMD ["php-fpm"]
