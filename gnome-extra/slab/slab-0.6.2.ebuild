# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit gnome2 eutils

DESCRIPTION="New main menu for gnome"
HOMEPAGE="http://www.gnome.org"
SRC_URI="http://ultra.hivalley.com/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="gnome-base/gnome-panel
		gnome-extra/gnome-system-monitor
		gnome-extra/yelp
		app-misc/beagle
		gnome-extra/gnome-screensaver
		net-misc/networkmanager
		x11-terms/gnome-terminal
		gnome-extra/gnome-power-manager
		>=app-portage/porthole-0.5*
		>=net-print/cups-1.2*
		>=net-print/gnome-cups-manager-0.31*
		>=app-admin/gnomesu-0.3.1-r2
		gnome-extra/nautilus-sendto"

src_unpack(){

	gnome2_src_unpack
	
	epatch ${FILESDIR}/control-center-apps.patch;
	epatch ${FILESDIR}/control-center-list.patch;
	epatch ${FILESDIR}/slab-schema.patch
	cp ${FILESDIR}/main-menu-porthole.desktop.in ${S}/main-menu/etc/
	sed -i -e 's/main-menu-rug/main-menu-porthole/g' \
	${S}/main-menu/etc/Makefile.* || die "Error modifying Makefiles"

}
