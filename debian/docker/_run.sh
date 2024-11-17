#!/bin/bash -x
set -x

cd /tmp/exaile/debian/

CURR_DIR=$PWD
TMP_DIR="$PWD/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
VER_STRING="${DEBIAN_VERSION}-${BUILD_VERSION}"
TAR_FILE="${PKG_NAME}_${DEBIAN_VERSION}.orig.tar.xz"
DESTDIR=$TMP_DIR$PKG_DIR
CHANGESFILE="${DESTDIR}.changes"

DESTDIR=$DESTDIR

rm -rf "${TMP_DIR}"
mkdir -p $DESTDIR/debian

cp -r current_stable/* $DESTDIR/debian

git config --global --add safe.directory /tmp/exaile


cd $TMP_DIR
uscan --force-download --debug


tar xf $TAR_FILE
cd $PKG_DIR
rm exaile-${EXAILE_VERSION}.tar.gz

## This happens on launchpad build server
dpkg-buildpackage -us -uc
dpkg-genchanges > $CHANGESFILE

lintian -IE --pedantic ../exaile-${EXAILE_VERSION}.changes

chmod -R 777 /tmp/exaile/debian/ex_build