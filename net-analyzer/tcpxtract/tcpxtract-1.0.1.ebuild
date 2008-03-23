# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils
DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://tcpxtract.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="
	>=net-libs/libpcap-0.9.8:0
	"
DEPEND="${RDEPEND}
	>=net-libs/libpcap-0.9.8:0
	>=sys-libs/glibc-2.7-r1:2.2
	>=sys-kernel/linux-headers-2.6.24:0
	"
src_compile() {
econf || die "econf failed"
emake || die "emake failed"
}
src_install() {
emake DESTDIR="${D}" install || die "emake install failed"
}
