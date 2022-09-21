#!/bin/bash -x
set -x

PKG_NAME="exaile"
EXAILE_VERSION="4.1.2"
PKG_VERSION="4.1.2+dfsg"
DEB_VERSION="1"
ARCH="all"
PPA="mentors" # official

CURR_DIR=$PWD
TMP_DIR="$PWD/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
VER_STRING="${PKG_VERSION}-${DEB_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200
TAR_FILE="exaile_4.1.2+dfsg.orig.tar.xz"

export DESTDIR=$TMP_DIR$PKG_DIR

CHANGESFILE="${DESTDIR}.changes"

rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR

mkdir -p $DESTDIR/debian
cp -r current_stable/* $DESTDIR/debian

sed -i "s/<#VERSION#>/$VER_STRING/g" $DESTDIR/debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" $DESTDIR/debian/changelog

cd $TMP_DIR
uscan --force-download
tar vxf $TAR_FILE

cd $PKG_DIR

## This happens on launchpad build server
dpkg-buildpackage -us -uc
dpkg-genchanges > $CHANGESFILE

lintian -IE --pedantic ../exaile-4.1.2.changes
exit

debsign -k exaile $CHANGESFILE
dput $PPA $CHANGESFILE

