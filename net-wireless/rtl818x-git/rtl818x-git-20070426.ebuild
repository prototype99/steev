# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Ralink drivers"
HOMEPAGE="http://rt2x00.serialmonkey.com/"
SRC_URI="${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-wireless/mac80211"
RDEPEND="net-wireless/mac80211"

S="${WORKDIR}/drivers/net/wireless/mac80211/rtl818x/"

libdir="net/wireless/mac80211/rtl818x/"
#MODULE_NAMES="rt2400pci(${libdir}) rt2500pci(${libdir}) rt2500usb(${libdir})
#	rt2x00lib(${libdir}) rt2x00pci(${libdir}) rt2x00usb(${libdir}) rt61pci(${libdir}) rt73usb(${libdir})"
BUILD_TARGETS="modules"
BUILD_PARAMS="CONFIG_RTL8187=m
		-C ${KERNEL_DIR} modules M=${S}"

MODULE_NAMES="rtl8187(${libdir})"

src_unpack() {
	unpack ${A}
	echo "CFLAGS += -I/usr/include/mac80211 -I${WORKDIR}/include -I/usr/include" >> ${S}/Makefile
}
