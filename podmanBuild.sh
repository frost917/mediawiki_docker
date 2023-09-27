#!/bin/sh

gitDir=$(dirname $(realpath $0))
mediawikiVer=1.40.0
mediawikiREL=REL1_40
mediawikiBackendVer=0.4
serviceName="mediawiki"
imageName="$serviceName"
imageTag="backend-$mediawikiBackendVer"
manifestName="$REGISTRY/$imageName:$imageTag"

# delete image manifest
podman --root $dataRoot image rm $manifestName

# create image manifest
podman --root $dataRoot manifest create $manifestName

# build images
for arch in amd64 arm64/v8
do 
	echo build $arch
	tag="$REGISTRY/$imageName-$arch:$imageTag"
	echo $tag
buildah bud \
	--root $dataRoot \
	--jobs=6 \
	--no-cache \
	--pull \
	--tag $tag \
	--platform linux/$arch \
	--build-arg MEDIAWIKI_VER=$mediawikiVer \
	--build-arg MEDIAWIKI_REL=$mediawikiREL \
	--build-arg REGISTRY=$REGISTRY \
	./image/fpm-buster

echo add new image in manifeset
podman --root $dataRoot manifest add $manifestName containers-storage:$tag
done

# push manifest
echo push manifest
podman --root $dataRoot manifest push --all --rm $manifestName docker://$manifestName
result=`echo $?`
echo $result

while true;
do
	if [[ $result != "0" ]]
	then
		podman --root $dataRoot manifest push --all --rm $manifestName docker://$manifestName
		result=`echo $1`
	else
		break
	fi
done
