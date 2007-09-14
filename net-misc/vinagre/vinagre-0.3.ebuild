# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="avahi"

RDEPEND=">=dev-libs/glib-2.11.0
	>=x11-libs/gtk+-2.11.0
	>=gnome-base/libglade-2.6.0
	>=gnome-base/gconf-2.16.0
	>=net-misc/gtk-vnc-1.0
	avahi? ( >=net-dns/avahi-0.6.18 )
	"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

pkg_setup() {
	G2CONF="$(use_enable avahi)"
}
