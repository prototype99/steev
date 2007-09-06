# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

MY_PN=NetworkManager

DESCRIPTION="Network configuration and management in an easy way. Desktop env independent"
HOMEPAGE="http://people.redhat.com/dcbw/NetworkManager/"
#http://ftp.gnome.org/pub/gnome/sources/NetworkManager/0.6/
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/NetworkManager/0.6/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt doc gnome"

RDEPEND=">=sys-apps/dbus-0.60
	>=sys-apps/hal-0.5
	sys-apps/iproute2
	>=dev-libs/libnl-1.0_pre6
	>=net-misc/dhcdbd-1.4
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.4.8
	>=dev-libs/glib-2.8
	>=x11-libs/libnotify-0.3.2
	gnome? ( >=x11-libs/gtk+-2.8
		>=gnome-base/libglade-2
		>=gnome-base/gnome-keyring-0.4
		>=gnome-base/gnome-panel-2
		>=gnome-base/gconf-2
		>=gnome-base/libgnomeui-2 )
	crypt? ( dev-libs/libgcrypt )"
	
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"
PDEPEND="gnome? ( >=gnome-extra/nm-applet-0.6.5 )"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"

G2CONF="${G2CONF} \
	`use_with crypt gcrypt` \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-distro=gentoo \
	--with-dbus-sys=/etc/dbus-1/system.d \
	--enable-notification-icon"

S=${WORKDIR}/${MY_PN}-${PV}

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
	epatch ${FILESDIR}/${PN}-0.6.5-confchanges.patch
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