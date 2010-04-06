# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="Utility to for advanced configuration of Razer mice (DeathAdder, Krait, Lachesis)"

HOMEPAGE="http://bu3sch.de/joomla/index.php/razer-nextgen-config-tool"
SRC_URI="http://bu3sch.de/${PN}/${P}.tar.bz2"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="qt"
RESTRICT="mirror"

RDEPEND="${DEPEND}
	qt? ( x11-libs/qt-core )
	dev-lang/python"
DEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	newinitd razerd.initscript razerd
	dodoc README
}
