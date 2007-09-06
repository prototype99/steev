# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Sakura is a terminal emulator based on GTK and VTE."
HOMEPAGE="http://pleyades.net/david/sakura.php"
SRC_URI="http://pleyades.net/david/projects/sakura/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	x11-libs/vte"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	./0 --prefix=/usr
}
