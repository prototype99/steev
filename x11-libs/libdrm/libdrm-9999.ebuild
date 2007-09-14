# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdrm/libdrm-2.0.2.ebuild,v 1.4 2006/08/24 07:57:10 corsair Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"
EGIT_BRANCH="master"

inherit git x-modular

DESCRIPTION="nouveau X.Org libdrm library"
HOMEPAGE="http://nouveau.freedesktop.org"
SRC_URI=""

KEYWORDS=""
RDEPEND=""
DEPEND="${RDEPEND}"


x-modular_unpack_source() {
	git_src_unpack
	
	if [[ -n ${FONT_OPTIONS} ]]; then
		einfo "Detected font directory: ${FONT_DIR}"
	fi
}

src_compile() {
	x-modular_src_compile

	cd ${S}/tests
	emake || die "Making test apps failed"
}

src_install() {
	x-modular_src_install

	cd ${S}/tests
	dobin dristat
	dobin drmstat
}

pkg_preinst() {
	x-modular_pkg_preinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		cp -pPR "${ROOT}"/usr/$(get_libdir)/libdrm.so.{1,1.0.0} "${IMAGE}"/usr/$(get_libdir)/
	fi
}

pkg_postinst() {
	x-modular_pkg_postinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		elog "You must re-compile all packages that are linked against"
		elog "libdrm 1 by using revdep-rebuild from gentoolkit:"
		elog "# revdep-rebuild --library libdrm.so.1"
		elog "After this, you can delete /usr/$(get_libdir)/libdrm.so.1"
		elog "and /usr/$(get_libdir)/libdrm.so.1.0.0 ."
		epause
	fi
}
