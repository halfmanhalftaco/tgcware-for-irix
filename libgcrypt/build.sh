#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libgcrypt
version=1.2.2
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libgcrypt-1.2.1-include.patch
patch[1]=libgcrypt-1.2.2-egd.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --enable-random=egd --disable-dev-random --with-egd-socket=/var/run/egd-pool'
ac_overrides="ac_cv_lib_socket_socket=no"

reg prep
prep()
{
    generic_prep
    setdir source
    autoconf
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc NEWS README README.apichanges THANKS TODO COPYING* AUTHORS
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
