# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION=""
HOMEPAGE="http://it.doesnt.have.one"
SRC_URI="http://steev.net/files/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-print/gnome-cups-manager"
DEPEND="${RDEPEND}"
