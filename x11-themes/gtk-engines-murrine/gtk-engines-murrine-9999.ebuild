# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils git gnome.org

EGIT_REPO_URI="git://git.gnome.org/murrine"
EGIT_BOOTSTRAP="autogen.sh"

MY_PN="murrine"
DESCRIPTION="Murrine GTK+2 Cairo Engine"

HOMEPAGE="http://www.cimitan.com/murrine/"
SRC_URI=""
#SRC_URI="${SRC_URI//${PN}/${MY_PN}}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="themes animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.12"
PDEPEND="themes? ( x11-themes/murrine-themes )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	sys-devel/gettext
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	econf --enable-animation \
		--enable-rgba \
		$(use_enable animation-rtl animationrtl)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog TODO
}
