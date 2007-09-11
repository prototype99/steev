# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Human icon theme from ubuntu"
HOMEPAGE="http://www.ubuntu.com/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/h/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=x11-themes/gtk-engines-ubuntulooks-0.9.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
