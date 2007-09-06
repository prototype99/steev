# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="UMIT is the new nmap frontend, intended to be cross plataform, easy to use, fast and highly customizable."
HOMEPAGE="http://umit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	>=dev-python/pygtk-2.6
	>=dev-python/pysqlite-2.0
	dev-python/psyco"
DEPEND="${RDEPEND}"
