#!/usr/local/bash/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=bash2
version=2.05b
pkgver=2
source[0]=bash-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${HOME}/buildpkg/scripts/buildpkg.functions

# Override pkginfo information
#pkgname=$pkgprefixbash2
name="bash - GNU Bourne-Again SHell"
pkgcat="application"
pkgvendor="http://www.gnu.org"
pkgdesc="Bash is an sh-compatible language interpreter"

# override topsrcdir
topsrcdir=bash-$version

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
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

reg all
all()
{
    for METHOD in $METHODS 
    do
	case $METHOD in
	     all*) ;;
	     *) $METHOD
		;;
	esac
    done

}

reg
usage() {
    echo Usage $0 "{"$(echo $METHODS | tr " " "|")"}"
    exit 1
}

OK=0
for METHOD in $*
do
    METHOD=" $METHOD *"
    if [ "${METHODS%$METHOD}" == "$METHODS" ] ; then
	usage
    fi
    OK=1
done

if [ $OK = 0 ] ; then
    usage;
fi

for METHOD in $*
do
    ( $METHOD )
done
