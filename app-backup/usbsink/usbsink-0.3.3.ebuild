# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="USBSink is a GNOME application to sync your files to a USB connected drive."
HOMEPAGE="http://usbsink.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-0.0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/fam
	>=dev-cpp/gtkmm-2.6.0
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gnome-vfsmm-2.12
	>=gnome-base/libgnome-2.6.0
	>=sys-apps/dbus-0.50
	>=sys-apps/hal-0.5.5
	dev-libs/libpcre"
DEPEND="${RDEPEND}"

