# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Cairo Composite Manager is a versatile and extensible composite manager which use cairo for rendering."
HOMEPAGE="http://cairo-compmgr.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/ccm/cairo-compmgr/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="gnome-base/gconf
	gnome-base/libgnomeui
	>=x11-libs/gtk+-2.10.0
	>=x11-libs/cairo-1.4.10
	x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXcomposite"
DEPEND="${RDEPEND}"

