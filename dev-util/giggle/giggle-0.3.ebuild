# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GTK+ gui for using git"
HOMEPAGE="http://developer.imendio.com"
SRC_URI="http://ftp.imendio.com/pub/imendio/giggle/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0
	>=x11-libs/gtk+-2.10
	>=x11-libs/gtksourceview-1.8
	>=gnome-base/libglade-2.4"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0"
