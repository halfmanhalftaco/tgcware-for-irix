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
topdir=tar
version=1.15.1
pkgver=3
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=tar-1.15.1-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CPPFLAGS="-I/usr/tgcware/include"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir ${srcdir}/${topsrcdir}
    aclocal -I ./m4 -I /usr/tgcware/share/aclocal
    automake --gnu
    autoconf
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
    $RMDIR ${stagedir}${prefix}/${_sbindir}
    doc ChangeLog README NEWS
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
