#!/bin/bash -x

PKG_NAME="exaile-master-daily"
PKG_VERSION="`date +%Y%m%d`"
DEB_VERSION="0ubuntu1"
ARCH="all"
PPA="ppa"
#PPA="exaile"

TMP_DIR="/tmp/ex_build/"
PKG_DIR="${PKG_NAME}_${PKG_VERSION}-${DEB_VERSION}_${ARCH}"
VER_STRING="${PKG_VERSION}-${DEB_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200

export DESTDIR=$TMP_DIR$PKG_DIR

CHANGESFILE="${DESTDIR}.changes"

cd ../exaile
git checkout master
git pull

cd -
rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR
mkdir -p $DESTDIR/debian

cp -r ../exaile/* $DESTDIR
cp -r current_head/* $DESTDIR/debian

cd $DESTDIR

sed -i "s/<#VERSION#>/$VER_STRING/g" debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" debian/changelog
sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/changelog
sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/control

## This happens on launchpad build server
#dpkg-buildpackage
#exit 0;
##

dpkg-source -b .
dpkg-genchanges > $CHANGESFILE
debsign -k Launchpad $CHANGESFILE
dput ppa:luzip665/$PPA $CHANGESFILE