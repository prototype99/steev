# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Real time satellite tracking program"
HOMEPAGE="http://groundstation.sourceforge.net/gpredict"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.10.0
	>=x11-libs/gtk+-2.8.0"

src_config() {
	econf --enable-coverage
}

src_install() {
	einstall || die install failed.
}
