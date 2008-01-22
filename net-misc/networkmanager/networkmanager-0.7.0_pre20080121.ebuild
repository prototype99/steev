# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

MY_PN=NetworkManager
MY_PV=${PV/_*/}

DESCRIPTION="Network configuration and management in an easy way. Desktop env independent"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
#http://ftp.gnome.org/pub/gnome/sources/NetworkManager/0.6/
SRC_URI="http://dev.gentoo.org/~steev/distfiles/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="crypt doc"

RDEPEND=">=dev-libs/dbus-glib-0.72
	>=sys-apps/hal-0.5
	sys-apps/iproute2
	>=dev-libs/libnl-1.1
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.6.2
	>=dev-libs/glib-2.8
	crypt? ( dev-libs/libgcrypt )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0"
PDEPEND="gnome? ( >=gnome-extra/nm-applet-0.6.5 )"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"

G2CONF="${G2CONF} \
	`use_with crypt gcrypt` \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-distro=gentoo \
	--with-ip=/sbin/ip"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_unpack () {

	unpack ${A}
	cd ${S}
	# Update to use our backend
	#epatch ${FILESDIR}/${PN}-updatedbackend.patch
	# Use the kernel headers
	epatch ${FILESDIR}/${PN}-use-kernel-headers.patch
	# Fix the resolv.conf permissions
	epatch ${FILESDIR}/${PN}-resolvconf-perms.patch
	# Fix up the dbus conf file to use plugdev group
	epatch ${FILESDIR}/${PN}-0.7.0-confchanges.patch
	# Update the includes, perhaps this will allow us to work with wireless...
	#epatch ${FILESDIR}/${PN}-update-includes.patch
}

src_install() {
	gnome2_src_install
	# Need to keep the /var/run/NetworkManager directory
	keepdir /var/run/NetworkManager
}
pkg_postinst() {
	gnome2_icon_cache_update
	elog "You need to be in the plugdev group in order to use NetworkManager"
	elog "Problems with your hostname getting changed?"
	elog ""
	elog "Add the following to /etc/dhcp/dhclient.conf"
	elog 'send host-name "YOURHOSTNAME";'
	elog 'supersede host-name "YOURHOSTNAME";'

	elog "You will need to restart DBUS if this is your first time"
	elog "installing NetworkManager."
}
