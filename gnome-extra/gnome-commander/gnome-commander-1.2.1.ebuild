# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A full featured, dual-pane file manager for Gnome2"
HOMEPAGE="http://www.nongnu.org/gcmd/"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/gnome-commander/1.2/${P}.tar.bz2"

IUSE="doc exif iptables"
SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2.6.0
	>=gnome-base/gnome-vfs-2.0
	>=dev-libs/glib-2.0.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/gconf-2.0
	|| (
		app-admin/fam
		app-admin/gamin
	)
	exif? media-libs/libexif
	iptables? net-firewall/iptables"

DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

src_install () {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO
}
