# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Mime Type-Editor for Gnome"

HOMEPAGE="http://www.kdau.com/projects/assogiate/"
SRC_URI="http://www.kdau.com/files/${P}.tar.bz2"
LICENSE="GPL2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-util/pkgconfig
	sys-devel/gettext
	sys-devel/libtool"
RDEPEND="${DEPEND}
	>=dev-cpp/glibmm-2.6
	>=dev-cpp/gtkmm-2.6
	>=dev-cpp/gnome-vfsmm-2.6
	>=dev-cpp/libxmlpp-2.6"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	einstall || die "einstall failed"
}
