# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GStreamer plugin for Win32 DLL loading"
HOMEPAGE="http://ronald.bitfreak.net/pitfdll.php"

MY_PN=${PN/gst-plugins-/}
MY_P=${MY_PN}-${PV}

SRC_URI="mirror://sourceforge/$MY_PN/$MY_P.tar.bz2"

# Create a major/minor combo for SLOT - stolen from gst-plugins-ffmpeg
PVP=(${PV//[-\._]/ })
SLOT=${PVP[0]}.${PVP[1]}

LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

S=${WORKDIR}/${MY_PN}

DEPEND="=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-base-0.10*"
RDEPEND="$DEPEND
	media-libs/win32codecs"

src_unpack() {
	unpack ${A}
	cd ${S}

	einfo "Running autogen.sh ..."
	( sh autogen.sh &> /dev/null --help ) || die "autogen failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
