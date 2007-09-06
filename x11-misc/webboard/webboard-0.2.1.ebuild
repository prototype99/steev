# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Web Board is a Gnome panel applet for pastebin"
HOMEPAGE="http://webb"
SRC_URI="http://somewhere.com/files/webboard_0.2.1.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/webboard_0.2.1-0ubuntu2.diff
}
