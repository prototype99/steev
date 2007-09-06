# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs pam eutils

MY_P=libpam-foreground-0.3

HOMEPAGE="http://www.kernel.org/pub/linux/libs/pam/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/libp/libpam-foreground/libpam-foreground_0.3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="virtual/pam"

DESCRIPTION="This is the pam_foreground module for PAM, allowing differentiation
from whether a user is at the console, or logged in remotely"

S=${WORKDIR}/${MY_P}

src_compile() {
	sed -e "s#:\%d.*#\"\,AUTH_DIR,user);#g" -i pam_foreground.c
	$(tc-getCC) -shared -fPIC ${CFLAGS} ${LDFLAGS} pam_foreground.c -o pam_foreground.so -lpam || die "pam_foreground build failed"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} check-foreground-console.c -o check-foreground-console || die "check-foreground-console build failed."
}

src_install() {

	dopammod pam_foreground.so
	dodir /var/run/console
	keepdir /var/run/console
	exeinto /usr/bin
	doexe	check-foreground-console
	dodoc debian/changelog debian/README.Debian
	echo
	elog "In order to enable the pam_foreground module, please follow"
	elog "the instructions in /usr/share/doc/${PF}/README.pam_console."
	echo
}
