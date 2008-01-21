# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnome2

MY_P="gtk-nodoka-engine-${PV}"

DESCRIPTION="Fedora GTK+ theme and engine"
HOMEPAGE="http://wish.i.nu"
SRC_URI="http://dev.gentoo.org/~steev/files/gtk-nodoka-engine-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S=${WORKDIR}/${MY_P}

DEPEND=">=x11-themes/gtk-engines-2.6.5
	>=x11-libs/gtk+-2.8.0"
RDEPEND="${DEPEND}"

G2CONF="${G2CONF} --enable-animation"
