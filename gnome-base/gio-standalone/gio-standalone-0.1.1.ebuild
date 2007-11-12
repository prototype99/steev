# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME I/O library for GVFS"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fam xattr"

RDEPEND="${DEPEND}
	>=dev-libs/glib-2.13.8
	fam? ( virtual/fam )
	xattr? ( sys-apps/attr )"
DEPEND="
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="--disable-selinux
		$(use_enable doc gtk-doc)
		$(use_enable fam)
		$(use_enable xattr)"
}
