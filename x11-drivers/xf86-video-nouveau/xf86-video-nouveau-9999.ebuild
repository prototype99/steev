# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-nv/xf86-video-nv-1.2.0.ebuild,v 1.1 2006/07/08 17:29:29 dberkholz Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"
XDPVER=2

#IUSE="randr12"

EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/xf86-video-nouveau"
#use randr12 && EGIT_BRANCH="randr-1.2"

inherit git x-modular

DESCRIPTION="nouveau X.Org driver for nv cards"
KEYWORDS=""

SRC_URI=""

RDEPEND=">=x11-base/xorg-server-1.3"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86driproto
	x11-proto/glproto
	=x11-libs/libdrm-9999"

x-modular_unpack_source() {
	git_src_unpack
	cd ${S}

	if [[ -n ${FONT_OPTIONS} ]]; then
		einfo "Detected font directory: ${FONT_DIR}"
	fi
}
