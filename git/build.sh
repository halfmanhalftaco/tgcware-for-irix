#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# Copyright (C) 2003-2009 Tom G. Christensen <tgc@jupiterrise.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Written by Tom G. Christensen <tgc@jupiterrise.com>.

# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=git
version=1.6.5.7
pkgver=1
source[0]=http://kernel.org/pub/software/scm/git/$topdir-$version.tar.bz2
source[1]=http://kernel.org/pub/software/scm/git/$topdir-manpages-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=git-1.6.5.3-trio.patch
patch[1]=git-1.6.5.3-socklen_t.patch
patch[2]=git-1.6.5.3-symlinks.patch
patch[3]=git-1.6.3.1-mapfailed.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=gcc
export PERL_PATH=$prefix/bin/perl
export SHELL_PATH=$prefix/bin/bash
no_configure=1
__configure="make -e"
configure_args=""
# HACK: -e must be last or echo will think it's an argument
__make="/usr/tgcware/bin/make -e"
make_build_target="V=1"
make_check_target="test"

reg prep
prep()
{
    generic_prep
    setdir source
    # Common defines for Irix 5.3 & 6.2
    cat <<EOF> config.mak
BASIC_CFLAGS += -I/usr/tgcware/include
BASIC_LDFLAGS += -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib
EXTLIBS += -ltrio
NEEDS_LIBICONV=YesPlease
NO_C99_FORMAT=YesPlease
NO_D_TYPE_IN_DIRENT=YesPlease
NO_INET_NTOP=YesPlease
NO_INET_PTON=YesPlease
NO_IPV6=YesPlease
NO_MEMMEM=YesPlease
NO_MKDTEMP=YesPlease
NO_SETENV=YesPlease
NO_SOCKADDR_STORAGE=YesPlease
NO_STRCASESTR=YesPlease
NO_STRLCPY=YesPlease
NO_STRTOUMAX=YesPlease
NO_UNSETENV=YesPlease
NO_PTHREADS=YesPlease
# trio (v)snprintf is fine
SNPRINTF_RETURNS_BOGUS=
prefix=$prefix
EOF

    if [ "$_os" = "irix53" ]; then
	# Defines for IRIX 5.3
	cat <<EOF>> config.mak
COMPAT_CFLAGS += -Icompat/regex -Icompat/fnmatch
COMPAT_OBJS += compat/regex/regex.o compat/fnmatch/fnmatch.o
FREAD_READS_DIRECTORIES=UnfortunatelyYes
NO_PREAD=YesPlease
EOF
    fi
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
    ${__mv} ${stagedir}${prefix}/${_sharedir}/man ${stagedir}${prefix}
    setdir ${stagedir}${prefix}/${_mandir}
    ${__tar} -xjf $(get_source_absfilename "${source[1]}")
    doc COPYING Documentation/RelNotes-${version}.txt README

    # fix git symlink
    ${__rm} -f ${stagedir}${prefix}/libexec/git-core/git
    ${__ln} -s ${prefix}/${_bindir}/git ${stagedir}${prefix}/libexec/git-core/git

    # cleanup perl install
    ${__rm} -rf ${stagedir}${prefix}/${_libdir}/perl5/5.*
    ${__rm} -rf ${stagedir}${prefix}/${_libdir}/perl5/site_perl/*/mips*
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/perl5/site_perl/*/Error.pm
}

reg check
check()
{
    setdir source
    ${__make} -k test
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
