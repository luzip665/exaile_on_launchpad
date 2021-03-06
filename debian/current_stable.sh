#!/bin/bash -x
set -x

PKG_NAME="exaile"
EXAILE_VERSION="4.1.2-beta1"
PKG_VERSION="4.1.2~beta1"
DEB_VERSION="1"
ARCH="all"
PPA="mentors" # official


TMP_DIR="/tmp/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
VER_STRING="${PKG_VERSION}-${DEB_VERSION}"
TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200
TAR_FILE="exaile_4.1.2~beta1.orig.tar.gz"

export DESTDIR=$TMP_DIR$PKG_DIR

CHANGESFILE="${DESTDIR}.changes"

cd ../exaile
git checkout $EXAILE_VERSION
#git checkout debian_packaging
git pull

cd -
rm -rf "${TMP_DIR}"

mkdir -p $DESTDIR
cp -r ../exaile/* $DESTDIR
cp -r overrides/* $DESTDIR

#Set version in exaile
sed -i "s|__version__ = \"devel\"|__version__ = \"$EXAILE_VERSION\"|" $DESTDIR/xl/version.py

cd $TMP_DIR
tar zcf $TMP_DIR/$TAR_FILE $PKG_DIR

cd -

mkdir -p $DESTDIR/debian
cp -r current_stable/* $DESTDIR/debian

sed -i "s/<#VERSION#>/$VER_STRING/g" $DESTDIR/debian/changelog
sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" $DESTDIR/debian/changelog

cd $DESTDIR

## This happens on launchpad build server
dpkg-buildpackage -us -uc
#exit
##

#dpkg-source -b .
dpkg-genchanges > $CHANGESFILE
debsign -k exaile $CHANGESFILE
dput $PPA $CHANGESFILE
