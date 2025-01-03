#!/bin/bash -x
set -x

PKG_NAME="exaile"
EXAILE_VERSION="4.1.4-beta1"
PKG_VERSION="4.1.4~beta1"
DEB_VERSION="0ubuntu0"
ARCH="all"
#PPA="ppa:luzip665/ppa" # Testing
#PPA="ppa:luzip665/exaile" # inofficial
PPA="ppa:exaile-devel/ppa" # official

TMP_DIR="/tmp/ex_build/"
PKG_DIR="${PKG_NAME}_${PKG_VERSION}-${DEB_VERSION}_${ARCH}"
VER_STRING="${PKG_VERSION}-${DEB_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200

export DESTDIR=$TMP_DIR$PKG_DIR

CHANGESFILE="${DESTDIR}.changes"

cd ../exaile
git checkout $EXAILE_VERSION
git pull

cd -
rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR
mkdir -p $DESTDIR/debian

cp -r ../exaile/* $DESTDIR
cp -r current_stable/* $DESTDIR/debian

cd $DESTDIR

sed -i "s/<#VERSION#>/$VER_STRING/g" debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" debian/changelog
sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/changelog
sed -i "s/<#UBUNTU_RELEASE#>/$UBUNTU_RELEASE/g" debian/changelog
sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/control

#Set version in exaile
sed -i "s|__version__ = \"devel\"|__version__ = \"$EXAILE_VERSION\"|" xl/version.py

## This happens on launchpad build server
#dpkg-buildpackage
#exit 0;
##

dpkg-source -b .
dpkg-genchanges > $CHANGESFILE
debsign -k exaile $CHANGESFILE
dput $PPA $CHANGESFILE
