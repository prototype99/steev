# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 python multilib

DESCRIPTION="A Desktop Synchronization Solution for GNOME"
HOMEPAGE="http://www.conduit-project.org/"
SRC_URI="http://files.conduit-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/python-2.4
		 >=x11-libs/gtk+-2.10
		 >=sys-apps/dbus-0.93
		 >=dev-python/pygtk-2.10
		   dev-python/pyxml
		   dev-python/vobject
		   dev-python/dbus-python
		   dev-python/pygoocanvas
		   dev-python/gnome-python
		   dev-python/python-dateutil"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19"

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/conduit
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
