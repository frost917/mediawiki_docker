FROM alpine/git AS clone

ENV MEDIAWIKI_REL REL1_36
ENV MEDIAWIKI_VERSION 1.36.1
ENV MEDIAWIKI_PATH /var/www/html
	
# docker nginx랑 권한 맞추기 위해 
RUN mkdir -p ${MEDIAWIKI_PATH} \ 
    && chown -R 101:101 ${MEDIAWIKI_PATH}

WORKDIR ${MEDIAWIKI_PATH}

USER 101

RUN git clone --depth 1  https://gerrit.wikimedia.org/r/mediawiki/core.git --branch ${MEDIAWIKI_REL} ${MEDIAWIKI_PATH} \
    # && cd ${MEDIAWIKI_PATH}/extensions \
    && git submodule update --init --recursive \ 
    && mkdir ${MEDIAWIKI_PATH}/icon

# add extensions
RUN cd ${MEDIAWIKI_PATH}/extensions \
    && git clone https://github.com/jmnote/SimpleMathJax.git SimpleMathJax \
    # && git clone https://gitlab.com/hydrawiki/extensions/EmbedVideo.git EmbedVideo \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector.git UniversalLanguageSelector \
# add skins
    && cd ${MEDIAWIKI_PATH}/skins \ 
    && git clone https://github.com/wikimedia/mediawiki-skins-MinervaNeue.git --branch ${MEDIAWIKI_REL} MinervaNeue \
    && cd ${MEDIAWIKI_PATH} \
    && git submodule update --init --recursive

FROM nginx:mainline-alpine

ENV MEDIAWIKI_PATH /var/www/html

WORKDIR ${MEDIAWIKI_PATH}

RUN rm -r ${MEDIAWIKI_PATH} \
    && mkdir ${MEDIAWIKI_PATH} \ 
    && chown -R nginx: ${MEDIAWIKI_PATH}

COPY --from=clone /var/www/html/ .