#!/bin/bash -x
set -x

PKG_NAME="exaile"
EXAILE_VERSION="4.1.3-beta3"
DEBIAN_VERSION="4.1.3~beta3+dfsg"
BUILD_VERSION="1"
ARCH="all"
PPA="mentors" # official

CURR_DIR=$PWD
TMP_DIR="$PWD/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
VER_STRING="${DEBIAN_VERSION}-${BUILD_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200
TAR_FILE="${PKG_NAME}_${DEBIAN_VERSION}.orig.tar.xz"
DESTDIR=$TMP_DIR$PKG_DIR
CHANGESFILE="${DESTDIR}.changes"

export DESTDIR=$DESTDIR


rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR/debian

cp -r current_stable/* $DESTDIR/debian
sed -i "s/<#VERSION#>/$VER_STRING/g" $DESTDIR/debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" $DESTDIR/debian/changelog

cd $TMP_DIR
uscan --force-download --debug

tar xf $TAR_FILE
cd $PKG_DIR
rm exaile-${EXAILE_VERSION}.tar.gz

## This happens on launchpad build server
dpkg-buildpackage -us -uc
dpkg-genchanges > $CHANGESFILE

if [ "$1" != "upload"];then
  lintian -IE --pedantic ../exaile-${EXAILE_VERSION}.changes
  exit
fi
debsign -k exaile $CHANGESFILE
dput $PPA $CHANGESFILE

