# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rtl8187/rtl8187-1.10.ebuild,v 1.2 2006/06/05 09:44:04 genstef Exp $

inherit linux-mod

MY_P=${PN}-${PV/_beta/-b}
DESCRIPTION="A new/clean Linux kernel driver/module for the Realtek's RTL818x chipset"
HOMEPAGE="http://sourceforge.net/projects/rtl818x"
SRC_URI="mirror://sourceforge/rtl818x/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
S=${WORKDIR}/${PN}

MODULE_NAMES="ieee80211_crypt-rtl(net/wireless/rtl818x:${S}/ieee80211)
	ieee80211_crypt_wep-rtl(net/wireless/rtl818x:${S}/ieee80211)
	ieee80211_crypt_tkip-rtl(net/wireless/rtl818x:${S}/ieee80211)
	ieee80211_crypt_ccmp-rtl(net/wireless/rtl818x:${S}/ieee80211)
	ieee80211-rtl(net/wireless/rtl818x:${S}/ieee80211) rtl818x(net/wireless/rtl818x)"
CONFIG_CHECK="NET_RADIO CRYPTO CRYPTO_ARC4 CRC32 !IEEE80211"
ERROR_IEEE80211="${P} requires the in-kernel version of the IEEE802.11 subsystem to be disabled (CONFIG_IEEE80211)"
BUILD_TARGETS="modules"
#MODULESD_R818x_ALIASES=("wlan0 r818x")

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KVERS=${KV_FULL} KSRC=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:MODVERDIR=$(PWD) ::' {,ieee80211/}Makefile
}

src_install() {
	linux-mod_src_install

	dodoc AUTHORS ChangeLog INSTALL README{,.adhoc,.master}
	newdoc ieee80211/README README.ieee80211
}
