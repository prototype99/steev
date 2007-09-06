# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a desktop search tool, providing a way to get different information on your desktop."
HOMEPAGE="http://code.google.com/p/affinity-search"
SRC_URI="http://${PN}-search.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="beagle tracker"

RDEPEND=">=x11-libs/gtk+-2
	gnome-base/libgnome
	gnome-base/libgnomeui
	gnome-base/gnome-vfs
	beagle? ( app-misc/beagle )
	tracker? ( app-misc/tracker )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-getenv.patch
}

src_compile() {
	econf $(use_enable beagle) $(use_enable tracker)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS
}
