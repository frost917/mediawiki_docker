FROM alpine/git AS clone

ARG WIKITYPE=mediawiki
ARG MEDIAWIKI_REL=REL1_37
ARG MEDIAWIKI_VERSION=1.37.0

ENV MEDIAWIKI_PATH /${WIKITYPE}

WORKDIR ${MEDIAWIKI_PATH}

RUN git clone --depth 1  https://github.com/wikimedia/mediawiki.git --branch ${MEDIAWIKI_REL} ${MEDIAWIKI_PATH} \
    # && cd ${MEDIAWIKI_PATH}/extensions \
    && mkdir ${MEDIAWIKI_PATH}/icon

# add extensions
RUN cd ${MEDIAWIKI_PATH}/extensions \
    && git clone https://github.com/jmnote/SimpleMathJax.git SimpleMathJax \
    # && git clone https://gitlab.com/hydrawiki/extensions/EmbedVideo.git EmbedVideo \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector.git UniversalLanguageSelector \
# add skins
    # && cd ${MEDIAWIKI_PATH}/skins \ 
    # && git clone https://github.com/wikimedia/mediawiki-skins-MinervaNeue.git --branch ${MEDIAWIKI_REL} MinervaNeue \
    && cd ${MEDIAWIKI_PATH} \
    && git submodule update --init --recursive

RUN chown 101:101 ${MEDIAWIKI_PATH}
