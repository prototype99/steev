# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

S=${WORKDIR}/${PN}-${PV/_/}
DESCRIPTION="GTK-based LDAP client"

SRC_URI="mirror://sourceforge/gqclient/${PN}-${PV/_/}.tar.gz"
HOMEPAGE="http://www.biot.com/gq/"
IUSE="kerberos nls ssl sasl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND=">=x11-libs/gtk+-2
	>=net-nds/openldap-2
	kerberos? ( app-crypt/mit-krb5 )
	ssl? ( dev-libs/openssl )
	dev-libs/libxml2
	>=dev-libs/glib-2
	x11-libs/pango
	sasl? ( dev-libs/cyrus-sasl )
	virtual/libc"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	local myconf="--enable-browser-dnd --enable-cache"

	use nls \
		&& myconf="${myconf} --with-included-gettext" \
		|| myconf="${myconf} --disable-nls"

	use kerberos && myconf="${myconf} --with-kerberos-prefix=/usr"

	econf $myconf || die "./configure failed"

	emake || die "Compilation failed"
}

src_install() {
	emake DESTDIR=${D} install || die "Installation failed"
	rm -f ${D}/usr/share/locale/locale.alias
	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING NEWS README* TODO
}

