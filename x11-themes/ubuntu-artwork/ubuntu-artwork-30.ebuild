# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${PN}_${PV}
DESCRIPTION="Artwork from the Ubuntu Linux distrobution"
HOMEPAGE="http://packages.ubuntu.com/edgy/gnome/ubuntu-artwork"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="x11-themes/gtk-engines-ubuntulooks"
DEPEND=">=gnome-base/gnome-common-2
	${RDEPEND}"

src_compile() {
	./autogen.sh
	econf
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc ChangeLog README
}
