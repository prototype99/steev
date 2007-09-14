# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="VNC viewer widget for GTK+"
HOMEPAGE="http://gtk-vnc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-python/pygtk
	>=net-libs/gnutls-1.4.0"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR=${D} install || die
}
