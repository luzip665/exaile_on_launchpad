#!/bin/bash -x

PKG_NAME="exaile-plugin-quickbuttons"
PKG_VERSION="0.1"
DEB_VERSION="0ubuntu5"
ARCH="all"

TMP_DIR="/tmp/ex_build/"
PKG_DIR="${PKG_NAME}_${PKG_VERSION}-${DEB_VERSION}_${ARCH}"
VER_STRING="${PKG_VERSION}-${DEB_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200

export DESTDIR=$TMP_DIR$PKG_DIR

CHANGESFILE="${DESTDIR}.changes"

cd ../exaile
git checkout Quickbuttons_Plugin

rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR/debian

cp -r ../exaile/plugins/quickbuttons/* $DESTDIR

cp -r plugin_quickbuttons/* $DESTDIR/debian

cd $DESTDIR

sed -i "s/<#VERSION#>/$VER_STRING/g" debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" debian/changelog

## This happens on launchpad build server
#dpkg-buildpackage
#exit 0;
##

dpkg-source -b .
dpkg-genchanges > $CHANGESFILE
debsign -k Launchpad $CHANGESFILE
dput ppa:luzip665/ppa $CHANGESFILE