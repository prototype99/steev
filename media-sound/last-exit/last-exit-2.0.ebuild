# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono gnome2 eutils

DESCRIPTION="Gnome/GTK+ alternative to the last.fm player"
HOMEPAGE="http://www.o-hand.com/~iain/last-exit/"
SRC_URI="http://www.o-hand.com/~iain/last-exit/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=gnome-base/gconf-2.0
		>=x11-libs/gtk+-2.6
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10
		>=media-plugins/gst-plugins-mad-0.10
		>=media-plugins/gst-plugins-gconf-0.10
		>=media-plugins/gst-plugins-gnomevfs-0.10
		>=dev-lang/mono-1.0
		>=dev-dotnet/gtk-sharp-1.9.2
		>=dev-dotnet/gnome-sharp-1.9.2
		>=dev-dotnet/glade-sharp-1.9.2
		>=dev-dotnet/gconf-sharp-1.9.2
		>=sys-apps/dbus-0.60"

pkg_setup() {
	G2CONF="${G2CONF} \
	--disable-schemas-install"
}

# Questionable legality here in the US...
#src_unpack() {
#	unpack ${A}
#	cd ${S}
#	epatch ${FILESDIR}/${PN}-2.0-save_song.patch
#}

src_install() {
	make DESTDIR=${D} install
}

pkg_postinst() {
	gnome2_pkg_postinst
}