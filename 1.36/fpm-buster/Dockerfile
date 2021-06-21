FROM alpine/git AS clone

ENV MEDIAWIKI_REL REL1_36
ENV MEDIAWIKI_VERSION 1.36.0
ENV MEDIAWIKI_PATH /var/www/html
	
# docker nginx랑 권한 맞추기 위해 
RUN mkdir -p ${MEDIAWIKI_PATH} \ 
    && chown -R 101:101 ${MEDIAWIKI_PATH}

WORKDIR ${MEDIAWIKI_PATH}

USER 101

RUN git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch ${MEDIAWIKI_REL} ${MEDIAWIKI_PATH} \
    && cd ${MEDIAWIKI_PATH}/extensions \
    && git submodule update --init --recursive

RUN mkdir ${MEDIAWIKI_PATH}/icon

# add extensions
RUN cd ${MEDIAWIKI_PATH}/extensions \
    && git clone https://github.com/jmnote/SimpleMathJax.git SimpleMathJax \
    && git clone https://gitlab.com/hydrawiki/extensions/EmbedVideo.git EmbedVideo \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector.git UniversalLanguageSelector \
# add skins
    && cd ${MEDIAWIKI_PATH}/skins \ 
    && git clone https://github.com/wikimedia/mediawiki-skins-MinervaNeue.git --branch ${MEDIAWIKI_REL} MinervaNeue \
    && cd ${MEDIAWIKI_PATH} \
    && git submodule update --init --recursive

FROM php:fpm-buster

RUN usermod -u 101 www-data 

RUN apt update \
    && apt install -y apt-utils \
    && apt install -y --no-install-recommends diffutils python3 imagemagick \
    && rm -rf /var/lib/apt/lists/*

ADD https://curl.haxx.se/ca/cacert.pem /
RUN chmod +r /cacert.pem

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd mysqli bcmath apcu bz2 intl redis @composer 

COPY --from=clone /var/www/html/ .

CMD ["php-fpm"]