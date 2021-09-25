#!/bin/sh

gitDir=$(dirname $(realpath $0))
ver="1.36"
specVer="1.36.1"

cd  ${gitDir}/${ver}/nginx-alpine/
podman build \
    --no-cache \
    --pull \
    --platform=linux/arm64/v8,linux/amd64 \
    -t ${REGISTRY}/mediawiki:${ver}-nginx-alpine \
    -t ${REGISTRY}/mediawiki:${specVer}-nginx-alpine \
    ./

podman image push \
    ${REGISTRY}/mediawiki:${ver}-nginx-alpine \
    ${REGISTRY}/mediawiki:${specVer}-nginx-alpine

cd ${gitDir}/${ver}/fpm-buster/
podman build \
    --no-cache \
    --pull \
    --platform=linux/arm64/v8,linux/amd64 \
    -t ${REGISTRY}/mediawiki:${ver}-fpm-buster \
    -t ${REGISTRY}/mediawiki:${specVer}-fpm-buster \
    ./

podman image push \
    ${REGISTRY}/mediawiki:${ver}-fpm-buster \
    ${REGISTRY}/mediawiki:${specVer}-fpm-buster