#!/bin/bash -x
#set -x

apt update
apt -y upgrade
pbuilder create --distribution testing

cd /tmp/exaile/debian/

CURR_DIR=$PWD
TMP_DIR="$PWD/ex_build/"
PKG_DIR="${PKG_NAME}-${EXAILE_VERSION}"
VER_STRING="${DEBIAN_VERSION}-${BUILD_VERSION}"
TAR_FILE="${PKG_NAME}_${DEBIAN_VERSION}.orig.tar.xz"
DESTDIR=$TMP_DIR$PKG_DIR
CHANGESFILE="${DESTDIR}.changes"
DSC_FILE="exaile_${VER_STRING}.dsc"

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

dpkg-source -b .

echo "Running pbuilder"

pbuilder build --twice ../$DSC_FILE

dpkg-genchanges > $CHANGESFILE

lintian -IE --pedantic --info ../exaile-${EXAILE_VERSION}.changes

lrc

chmod -R 777 /tmp/exaile/debian/ex_build