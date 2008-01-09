# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-2.20.1.ebuild,v 1.1 2007/10/17 21:29:36 eva Exp $

inherit gnome2 eutils multilib subversion

DESCRIPTION="GNOME webbrowser based on the mozilla rendering engine"
HOMEPAGE="http://www.gnome.org/projects/epiphany/"
SRC_URI=""

ESVN_PROJECT="epiphany"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"
ESVN_REPO_URI="http://svn.gnome.org/svn/epiphany/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc firefox python xulrunner spell webkit"

# FIXME: add webkit/gecko switch possibility
# dang: *after* webkit actually works.

RDEPEND=">=dev-libs/glib-2.13.4
	>=x11-libs/gtk+-2.11.6
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/libglade-2.3.1
	>=gnome-base/gnome-vfs-2.9.2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=gnome-base/gnome-desktop-2.9.91
	>=x11-libs/startup-notification-0.5
	>=dev-libs/dbus-glib-0.71
	>=gnome-base/gconf-2
	>=app-text/iso-codes-0.35
	firefox? ( >=www-client/mozilla-firefox-1.5 )
	xulrunner? ( net-libs/xulrunner )
	webkit? ( net-libs/webkit )
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygtk-2.7.1
		>=dev-python/gnome-python-2.6 )
	spell? ( app-text/enchant )
	x11-themes/gnome-icon-theme"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2
	>=gnome-base/gnome-common-2.12.0
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	if use webkit; then
		if use xulrunner || use firefox; then
			die "Please choose only one rendering engine (xulrunner, firefox, webkit)"
		fi
		G2CONF="--with-engine=webkit"
	fi
	if use firefox || use xulrunner; then
		if use firefox && use xulrunner; then
			die "Please choose only one rendering engine (xulrunner, firefox, webkit)"
		fi
		G2CONF="--with-engine=mozilla"
		if use xulrunner; then
			G2CONF="${G2CONF} --with-gecko=xulrunner"
		else
			G2CONF="${G2CONF} --with-gecko=firefox"
		fi
	fi
		
	G2CONF="${G2CONF} --disable-scrollkeeper \
		$(use_enable spell spell-checker)
		$(use_enable python)"
}

src_compile() {
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/xpti.dat
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/xpti.dat.tmp
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/compreg.dat.tmp

	addpredict /usr/$(get_libdir)/xulrunner/components/xpti.dat
	addpredict /usr/$(get_libdir)/xulrunner/components/xpti.dat.tmp
	addpredict /usr/$(get_libdir)/xulrunner/components/compreg.dat.tmp

	addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat
	addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat.tmp

	gnome2_src_compile
}