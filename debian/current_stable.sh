#!/bin/bash -x
#set -x

export PKG_NAME="exaile"
export EXAILE_VERSION="4.1.4-beta1"
export DEBIAN_VERSION="4.1.4~beta1+dfsg"
export BUILD_VERSION="1"

PPA="mentors" # official

CURR_DIR=$PWD
TMP_DIR="$PWD/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
DESTDIR=$TMP_DIR$PKG_DIR
CHANGESFILE="${DESTDIR}.changes"

export PATH_TO_EXAILE=$(dirname "$CURR_DIR")
export DESTDIR=$DESTDIR



cd docker
bash build.sh  | tee ../build.log

cd ..

if [ "X$1" != "Xupload" ];then
  exit
fi
debsign -k exaile $CHANGESFILE
dput $PPA $CHANGESFILE

