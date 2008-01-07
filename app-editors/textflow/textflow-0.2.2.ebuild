# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="The TextFlow is a text editor directed toward programmers."
HOMEPAGE="http://sourceforge.net/projects/textflow/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-python/pygtksourceview"
DEPEND="${RDEPEND}"

