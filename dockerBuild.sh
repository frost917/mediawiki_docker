#!/bin/sh
gitDir=$(dirname $(realpath $0))
ver="1.36"
specVer="1.36.1"

#  build
cd  ${gitDir}/${ver}/nginx-alpine/
docker buildx build \
    --push \
    --platform=linux/arm64,linux/amd64 \
    -t ${REGISTRY}/mediawiki:${ver}-nginx-alpine \
    -t ${REGISTRY}/mediawiki:${specVer}-nginx-alpine \
    ./ 

cd ${gitDir}/${ver}/fpm-buster/
docker buildx build \
    --push \
    --platform=linux/arm64,linux/amd64 \
    -t ${REGISTRY}/mediawiki:${ver}-fpm-buster \
    -t ${REGISTRY}/mediawiki:${specVer}-fpm-buster \
    ./
