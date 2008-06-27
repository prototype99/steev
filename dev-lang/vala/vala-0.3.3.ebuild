# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Vala is a new programming language that aims to bring modern programming language features to GNOME developers without imposing any additional runtime requirements and without using a different ABI compared to applications and libraries written in C."
HOMEPAGE="http://vala.paldo.org"
#SRC_URI="http://www.paldo.org/vala/${P}.tar.bz2"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/vala/0.3/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=dev-libs/glib-2.10.0
	>=x11-libs/gtk+-2.10.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

#src_unpack() {
#	unpack ${A}
#	cd "${S}/gen-project"
#	epatch "${FILESDIR}/${PN}-automake-paths.patch"
#}

src_compile() {
	econf --enable-vapigen --enable-gen-project
}
src_install() {
	make DESTDIR=${D} install || die "Install failed"
}
