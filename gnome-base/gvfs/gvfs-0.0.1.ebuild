# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fuse samba"

RDEPEND="${DEPEND}
	>=dev-libs/glib-2.13.8
	gnome-base/gio-standalone
	sys-apps/dbus
	fuse? ( sys-fs/fuse )
	samba? ( >=net-fs/samba-3 )"
DEPEND="
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="$(use_enable doc gtk-doc)
		$(use_enable fuse)
		$(use_enable samba)"
}
