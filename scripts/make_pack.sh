#!/bin/bash

########################################################################
#  This file is part of PLGI.
#
#   Copyright (C) 2015 Keri Harris <keri@gentoo.org>
#
#   PLGI is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as
#   published by the Free Software Foundation, either version 2.1
#   of the License, or (at your option) any later version.
#
#   PLGI is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with PLGI.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

SCRIPT=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPT")
TOPDIR=$SCRIPTDIR/..

VERSION=$(cat $TOPDIR/VERSION)

VERSION_MAJOR=$(grep "#define PLGI_VERSION_MAJOR" $TOPDIR/src/plgi.h | sed -e "s:.* ::")
VERSION_MINOR=$(grep "#define PLGI_VERSION_MINOR" $TOPDIR/src/plgi.h | sed -e "s:.* ::")
VERSION_MICRO=$(grep "#define PLGI_VERSION_MICRO" $TOPDIR/src/plgi.h | sed -e "s:.* ::")
if [[ "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_MICRO}" != "$VERSION" ]]; then
	echo "Version mismatch between VERSION and plgi.h"
	exit
fi

cd $TOPDIR
make distclean

cd $SCRIPTDIR
rm -rf pack-$VERSION

mkdir -p pack-$VERSION/plgi
echo "name('plgi')." > pack-$VERSION/plgi/pack.pl
echo "title('PLGI - Prolog bindings for GLib/GObject/GIO/GTK+')." >> pack-$VERSION/plgi/pack.pl
echo "version('$VERSION')." >> pack-$VERSION/plgi/pack.pl
echo "author('Keri Harris', 'keri@gentoo.org')." >> pack-$VERSION/plgi/pack.pl
echo "download('http://dev.gentoo.org/~keri/plgi/plgi-*.tgz')." >> pack-$VERSION/plgi/pack.pl

mkdir -p pack-$VERSION/plgi/prolog
cp $TOPDIR/prolog/plgi.pl pack-$VERSION/plgi/prolog/
mkdir -p pack-$VERSION/plgi/prolog/plgi
cp $TOPDIR/prolog/overrides/*.pl pack-$VERSION/plgi/prolog/plgi/

mkdir -p pack-$VERSION/plgi/src
cp $TOPDIR/src/*.{c,h} pack-$VERSION/plgi/src/
cp $TOPDIR/src/config.h.in pack-$VERSION/plgi/src/
cp $TOPDIR/src/Makefile.in pack-$VERSION/plgi/src/
sed -i -e "s:@SWI_SOLIBDIR@:../\$(PACKSODIR):" \
       -e "s:@SWI_PLLIBDIR@:../prolog:" \
       -e "/\$(INSTALL_PROGRAM)/{h;N;N;N;N;N;x}" pack-$VERSION/plgi/src/Makefile.in

mkdir -p pack-$VERSION/plgi/test
cp $TOPDIR/test/*.{pl,c,h} pack-$VERSION/plgi/test/
cp $TOPDIR/test/Makefile.in pack-$VERSION/plgi/test/
sed -i -e "/SWI_BASE/d" pack-$VERSION/plgi/test/Makefile.in

mkdir -p pack-$VERSION/plgi/examples
cp $TOPDIR/examples/*.pl pack-$VERSION/plgi/examples/
cp $TOPDIR/examples/*.png pack-$VERSION/plgi/examples/
cp $TOPDIR/examples/*.glade pack-$VERSION/plgi/examples/
cp $TOPDIR/examples/COPYING pack-$VERSION/plgi/examples/

cp $TOPDIR/README pack-$VERSION/plgi/
cp $TOPDIR/LICENSE pack-$VERSION/plgi/
cp $TOPDIR/VERSION pack-$VERSION/plgi/

cp $TOPDIR/configure.in pack-$VERSION/plgi/
sed -i -e "/SWI_BASE/d" \
       -e "/SWI_ARCH/d" \
       -e "/SWI_SOLIBDIR/d" \
       -e "/SWI_PLLIBDIR/d" \
       -e "/PKG_CHECK_MODULES(SWI/{N;N;d}" pack-$VERSION/plgi/configure.in
cp $TOPDIR/aclocal.m4 pack-$VERSION/plgi/
cp $TOPDIR/install-sh pack-$VERSION/plgi/
cp $TOPDIR/Makefile.in pack-$VERSION/plgi/
sed -i -e "s: check: -i check:" pack-$VERSION/plgi/Makefile.in

cd pack-$VERSION
tar -cvzf plgi-$VERSION.tgz plgi
