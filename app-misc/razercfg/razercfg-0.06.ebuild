# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

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

src_prepare() {
	sed -e 's/SYSFS{idVendor}/ATTRS{vendor}/' \
		-i "${S}"/01-razer-udev.rules.template
}
	

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/razerd.init" razerd
	dodoc README
	if ! use qt; then
		rm "${D}"/usr/bin/qrazercfg
	fi
}

pkg_postinst() {
	udevadm control --reload-rules && udevadm trigger --subsystem-match=usb
}
