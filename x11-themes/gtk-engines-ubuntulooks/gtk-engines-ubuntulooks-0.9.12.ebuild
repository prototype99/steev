# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN=ubuntulooks
MY_P=${MY_PN}_${PV}
DESCRIPTION="Ubuntu GTK 2 Theme Engine (based on Clearlooks)"
HOMEPAGE="http://packages.ubuntu.com/edgy/gnome/gtk2-engines-ubuntulooks"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/u/${MY_PN}/${MY_P}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd65 ~ppc ~x86"

S=${WORKDIR}/${MY_PN}-${PV}

DEPEND=">=x11-libs/gtk+-2.8.8"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${MY_P}-5.diff
}

src_compile() {
	econf
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc ChangeLog README
}
