# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools eutils

DESCRIPTION="exempi is a port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="http://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="dev-libs/expat
	virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/boost-1.33.1 )"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	if use test ; then
		epatch "${FILESDIR}/${P}-unit-test-m4.patch"
		epatch "${FILESDIR}/${P}-tests-boost-1.34.patch"
	else
		sed -e '/AX_BOOST/ D' -i configure.ac
	fi
	eautoconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README
	if use examples ; then
		cd samples/source
		emake distclean
		cd "${S}"
		rm samples/Makefile* samples/source/Makefile* \
			samples/BlueSquares/Makefile*
		insinto "/usr/share/doc/${PF}"
		doins -r samples
	fi
}
