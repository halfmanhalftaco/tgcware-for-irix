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
topdir=zlib
version=1.2.3
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args='--shared --prefix=$prefix' 
export LDSHARED="gcc -shared -rpath ${prefix}/${_libdir} -Wl,-soname,libz.so.1"
check_ac=0
shortroot=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    $MAKE_PROG test
}

reg install
install()
{
    generic_install prefix
    setdir source
    doc README ChangeLog algorithm.txt minigzip.c example.c
    setdir stage
    $MV ${stagedir}${prefix}/share/${_mandir} ${stagedir}${prefix}
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
