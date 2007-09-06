# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Vala is a new programming language that aims to bring modern programming language features to GNOME developers without imposing any additional runtime requirements and without using a different ABI compared to applications and libraries written in C."
HOMEPAGE="http://vala.paldo.org"
#SRC_URI="http://www.paldo.org/vala/${P}.tar.bz2"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/vala/0.1/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=dev-libs/glib-2.10.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die "Install failed"
}