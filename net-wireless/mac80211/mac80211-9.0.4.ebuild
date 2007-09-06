# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="mac80211 subsystem"
HOMEPAGE="http://intellinuxwireless.org/?p=mac80211"
SRC_URI="http://intellinuxwireless.org/${PN}/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="kernel_linux? ( virtual/linux-sources )"
RDEPEND=""

S="${WORKDIR}/${P}/compatible/net"

MODULE_NAMES="mac80211(net/mac80211:${S}/mac80211)
	rc80211_simple(net/mac80211:${S}/mac80211)
	cfg80211(net/wireless:${S}/wireless)"
BUILD_PARAMS="CONFIG_MAC80211_LEDS=m CONFIG_MAC80211=m CONFIG_CFG80211=m
	-C ${KERNEL_DIR} M=\${PWD}"
BUILD_TARGETS="modules"
CONFIG_CHECK="NET_SCHED WIRELESS_EXT"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/${P} ; make unmodified KSRC=${KERNEL_DIR} ||
		die "make unmodified failed"
	for i in ${S}/mac80211 ${S}/wireless ; do
		echo "CFLAGS += -I${WORKDIR}/${P}/compatible/include" >> $i/Makefile
	done
}

src_install() {
	cd ${WORKDIR}/${P}/compatible
	for i in include/net include/linux ; do
		dodir /usr/include/${i/include/mac80211}
		insinto /usr/include/${i/include/mac80211}
		doins $i/*.h
	done

	dodir /usr/include/mac80211/net/mac80211
	insinto /usr/include/mac80211/net/mac80211
	doins net/mac80211/*.h

	linux-mod_src_install
}
