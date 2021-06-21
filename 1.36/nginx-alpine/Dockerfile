FROM nginx:alpine

ENV MEDIAWIKI_REL REL1_36
ENV MEDIAWIKI_VERSION 1.36.0
ENV MEDIAWIKI_PATH /var/www/html

RUN apk update \
    && apk add --no-cache git

WORKDIR ${MEDIAWIKI_PATH}

RUN rm -r ${MEDIAWIKI_PATH} \
    && mkdir ${MEDIAWIKI_PATH} \ 
    && chown -R nginx ${MEDIAWIKI_PATH}

RUN git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch ${MEDIAWIKI_REL} ${MEDIAWIKI_PATH} \
    && cd ${MEDIAWIKI_PATH} \
    && git checkout ${MEDIAWIKI_VERSION} \
    && cd ${MEDIAWIKI_PATH}/extensions \
    && git submodule update --init --recursive

RUN mkdir ${MEDIAWIKI_PATH}/icon