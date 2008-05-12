# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools flag-o-matic

DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkit.org/"
MY_P="WebKit-r${PV}"
SRC_URI="http://nightly.webkit.org/files/trunk/src/${MY_P}.tar.bz2"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug gstreamer sqlite svg"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=x11-libs/gtk+-2.0
	dev-libs/icu
	>=net-misc/curl-7.15
	media-libs/jpeg
	media-libs/libpng
	dev-libs/libxslt
	dev-libs/libxml2
	sqlite? ( >=dev-db/sqlite-3 )
	gstreamer? ( >=media-libs/gstreamer-0.10
			>=media-libs/gst-plugins-base-0.10
			>=gnome-base/gnome-vfs-2.0 )"
DEPEND="${RDEPEND}
		sys-devel/bison
		dev-util/gperf
		>=sys-devel/flex-2.5.33"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	local myconf="$(use_enable sqlite database)	\
					$(use_enable sqlite icon-database)	\
					$(use_enable svg)"

	if use debug; then
		myconf="${myconf} --enable-debug"
	fi

	if use gstreamer ; then
		myconf="${myconf} --enable-video"
	fi
	
	# Doesn't build with as-needed
	filter-ldflags -Wl,--as-needed

	econf ${myconf} || die "configure failed"
	emake -j1 || die "emake failed"
}

src_install() {
		einstall || die "Installation failed"
}
