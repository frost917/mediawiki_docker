# #!/bin/bash

gitDir=$(dirname $(realpath $0))
mediawikiVer=1.40.0
mediawikiREL=REL1_40
serviceName="mediawiki"
imageName="$serviceName"
imageTag="source-$mediawikiVer"
manifestName="$REGISTRY/$imageName:$imageTag"

# flush cache data
# podman --root $dataRoot rmi --all --force

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
	--tag $tag \
	--platform linux/$arch \
	--build-arg MEDIAWIKI_VERSION=$mediawikiVer \
	--build-arg MEDIAWIKI_REL=$mediawikiREL \
	./

echo add new image in manifeset
podman --root $dataRoot manifest add $manifestName containers-storage:$tag
done

# push manifest
echo push $manifestName
podman --root $dataRoot manifest push --all --rm $manifestName docker://$manifestName
result=`echo $?`
echo $result

while true;
do
	if [[ $result != "0" ]];
	then
		podman --root $dataRoot manifest push --all --rm $manifestName docker://$manifestName
		result=`echo $1`
	else
		break
	fi
done
