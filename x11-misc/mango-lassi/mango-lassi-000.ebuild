# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Mango-Lassi is an app similar to synergy or x2x but doesn't suck"
HOMEPAGE="http://0pointer.de/blog/projects/mango-lassi.html"
SRC_URI="http://steev.net/files/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=sys-apps/dbus-1.1.1
	net-dns/avahi
	x11-libs/libnotify
	gnome-base/libglade
	>=x11-libs/gtk+-2.10
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0"

