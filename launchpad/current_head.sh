#!/bin/bash -x

upload() {

  UBUNTU_RELEASE="$1"

  PKG_NAME="exaile-master-daily"
#  PKG_NAME="exaile-master-daily-${UBUNTU_RELEASE}"
  PKG_VERSION="`date +%Y%m%d%H%M`"
  DEB_VERSION="0ubuntu1"
  ARCH="all"
#  PPA="ppa:luzip665/ppa" # Testing
  PPA="ppa:luzip665/exaile" # inofficial

  TMP_DIR="/tmp/ex_build/"
  VER_STRING="${PKG_VERSION}-${DEB_VERSION}~${UBUNTU_RELEASE}"
  PKG_DIR="${PKG_NAME}_${VER_STRING}_${ARCH}"
  TIMESTAMP=`date -R` # Thu, 23 Sep 2010 21:36:01 +0200

  export DESTDIR=$TMP_DIR$PKG_DIR
  CHANGESFILE="${DESTDIR}.changes"

  rm -rf "${TMP_DIR}"
  mkdir -p $DESTDIR
  mkdir -p $DESTDIR/debian

  cp -r ../exaile/* $DESTDIR
  cp -r current_head/* $DESTDIR/debian

  cd $DESTDIR

  sed -i "s/<#VERSION#>/$VER_STRING/g" debian/changelog
  sed -i "s/<#TIMESTAMP#>/$TIMESTAMP/g" debian/changelog
  sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/changelog
  sed -i "s/<#UBUNTU_RELEASE#>/$UBUNTU_RELEASE/g" debian/changelog
  sed -i "s/<#PKG_NAME#>/$PKG_NAME/g" debian/control

  ## This happens on launchpad build server
  #dpkg-buildpackage
  #exit 0;
  ##

  dpkg-source -b .
  dpkg-genchanges > $CHANGESFILE
  debsign -k exaile $CHANGESFILE
  dput $PPA $CHANGESFILE

  cd -
}

cd ../exaile
git checkout master
git pull

cd -

upload "bionic"
upload "focal"
upload "jammy"
upload "noble"
upload "oracular"
