#!/bin/bash -x
#set -x

CONTAINERNAME="exaile-debian"
BASE_IMAGE='debian:unstable-slim'
TARGET_IMAGE=exaile_base

LIST=`docker ps -a -f "name=$CONTAINERNAME" | wc -l`
EXISTS=`test $LIST -eq 2 && echo true`

/usr/bin/docker stop $CONTAINERNAME
docker rm $CONTAINERNAME
docker pull "$BASE_IMAGE"
docker buildx build \
  --build-arg BASE_IMAGE="$BASE_IMAGE" \
  --build-arg PKG_NAME=$PKG_NAME \
  --build-arg EXAILE_VERSION=$EXAILE_VERSION \
  --build-arg DEBIAN_VERSION=$DEBIAN_VERSION \
  --build-arg BUILD_VERSION=$BUILD_VERSION \
  -t $TARGET_IMAGE .
docker run --name $CONTAINERNAME --mount type=bind,src="$PATH_TO_EXAILE",dst=/tmp/exaile "$TARGET_IMAGE"

