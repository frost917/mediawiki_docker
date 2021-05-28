FROM php:fpm-buster

ENV MEDIAWIKI_REL REL1_35
ENV MEDIAWIKI_VERSION 1.35.2
ENV MEDIAWIKI_PATH /var/www/html
	
WORKDIR ${MEDIAWIKI_PATH}

RUN apt update \
    && apt install -y apt-utils \
    && apt install -y --no-install-recommends git diffutils python3 imagemagick \
    && rm -rf /var/lib/apt/lists/*

ADD https://curl.haxx.se/ca/cacert.pem /
RUN chmod +r /cacert.pem

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd mysqli bcmath apcu bz2 intl redis @composer 

# docker nginx랑 권한 맞추기 위해 
RUN rm -r ${MEDIAWIKI_PATH} \
    && mkdir ${MEDIAWIKI_PATH} \ 
    && chown -R www-data ${MEDIAWIKI_PATH} \
    && usermod -u 101 www-data
USER www-data

RUN git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch ${MEDIAWIKI_REL} ${MEDIAWIKI_PATH} \
    && cd ${MEDIAWIKI_PATH} \
    && git checkout ${MEDIAWIKI_VERSION} \
    && cd ${MEDIAWIKI_PATH}/extensions \
    && git submodule update --init --recursive

RUN mkdir ${MEDIAWIKI_PATH}/icon ${MEDIAWIKI_PATH}/images ${MEDIAWIKI_PATH}/skins 

CMD ["php-fpm"]
