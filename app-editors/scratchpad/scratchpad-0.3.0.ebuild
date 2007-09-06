# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Scratchpad is a lightweight but useful spatial text editor for the
GNOME desktop, based on gtksourceview."
HOMEPAGE="http://dborg.wordpress.com/"
SRC_URI="http://www.chorse.org/stuff/scratchpad/scratchpad-0.3.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtksourceview-1.8.0
	>=gnome-base/gnome-vfs-2.16.0"
DEPEND=""

