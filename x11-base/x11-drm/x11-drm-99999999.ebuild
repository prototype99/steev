# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/x11-drm/x11-drm-20060608.ebuild,v 1.2 2006/06/16 07:09:43 battousai Exp $

EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"
EGIT_BRANCH="master"

inherit git eutils x11 linux-mod autotools

IUSE_VIDEO_CARDS="
	video_cards_i810
	video_cards_mach64
	video_cards_mga
	video_cards_nv
	video_cards_r128
	video_cards_radeon
	video_cards_savage
	video_cards_sis
	video_cards_sunffb
	video_cards_tdfx
	video_cards_via
	video_cards_nouveau"
IUSE="${IUSE_VIDEO_CARDS}"

# Make sure Portage does _NOT_ strip symbols.
RESTRICT="nostrip"

DESCRIPTION="nouveau DRM Kernel Modules for X11"
HOMEPAGE="http://dri.sf.net"
SRC_URI=""

SLOT="0"
LICENSE="X11"
KEYWORDS=""

DEPEND=">=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.59
	>=sys-devel/libtool-1.5.14
	>=sys-devel/m4-1.4
	virtual/linux-sources
	>=sys-apps/portage-2.0.49-r13"

pkg_setup() {
	get_version

	if kernel_is 2 6
	then
		if linux_chkconfig_builtin "DRM"
		then
			die "Please disable or modularize DRM in the kernel config. (CONFIG_DRM = n or m)"
		fi

		if ! linux_chkconfig_present "AGP"
		then
			einfo "AGP support is not enabled in your kernel config. This may be needed for DRM to"
			einfo "work, so you might want to double-check that setting. (CONFIG_AGP)"
			echo
		fi
	else
		die "Only 2.6 kernel series supported."
	fi

	# Set video cards to build for.
	set_vidcards

	get_drm_build_dir

	return 0
}

src_unpack() {
	git_src_unpack

	# Apply patches
	epatch "${FILESDIR}/makefile.patch"
	
	# Substitute new directory under /lib/modules/${KV_FULL}
	sed -i -e "s:/kernel/drivers/char/drm:/${PN}:g" ${SRC_BUILD}/Makefile
}

src_compile() {
	einfo "Building DRM in ${SRC_BUILD}..."
	cd ${SRC_BUILD}

	# This now uses an M= build system. Makefile does most of the work.
	unset ARCH
	make M="${SRC_BUILD}" \
		LINUXDIR="${KERNEL_DIR}" \
		DRM_MODULES="${VIDCARDS}" \
		modules || die_error
	cd ${S}
}

src_install() {
	einfo "Installing DRM..."
	cd ${SRC_BUILD}

	unset ARCH
	DRM_KMOD="drm.${KV_OBJ}"
	make KV="${KV_FULL}" \
		LINUXDIR="${KERNEL_DIR}" \
		DESTDIR="${D}" \
		RUNNING_REL="${KV_FULL}" \
		MODULE_LIST="${VIDCARDS} ${DRM_KMOD}" \
		install_for_gentoo || die "Install failed."

	dodoc README.drm

	# Yoinked from the sys-apps/touchpad ebuild. Thanks to whoever made this.
	keepdir /etc/modules.d
	sed 's:%PN%:'${PN}':g' ${FILESDIR}/modules.d-${PN} > ${D}/etc/modules.d/${PN}
	sed -i 's:%KV%:'${KV_FULL}':g' ${D}/etc/modules.d/${PN}
}

pkg_postinst() {
	einfo "Checking kernel module dependencies"
	update_modules
	update_depmod
}

# Functions used above are defined below:

set_vidcards() {
	set_kvobj

	POSSIBLE_VIDCARDS="mga tdfx r128 radeon i810 i830 i915 mach64 nv savage
		sis via nouveau"
	if use sparc; then
		POSSIBLE_VIDCARDS="${POSSIBLE_VIDCARDS} ffb"
	fi
	VIDCARDS=""

	if [[ -n "${VIDEO_CARDS}" ]]; then
		use video_cards_i810 && \
			VIDCARDS="${VIDCARDS} i810.${KV_OBJ} i830.${KV_OBJ} i915.${KV_OBJ}"
		use video_cards_mach64 && \
			VIDCARDS="${VIDCARDS} mach64.${KV_OBJ}"
		use video_cards_mga && \
			VIDCARDS="${VIDCARDS} mga.${KV_OBJ}"
		use video_cards_nv && \
			VIDCARDS="${VIDCARDS} nv.${KV_OBJ}"
		use video_cards_r128 && \
			VIDCARDS="${VIDCARDS} r128.${KV_OBJ}"
		use video_cards_radeon && \
			VIDCARDS="${VIDCARDS} radeon.${KV_OBJ}"
		use video_cards_savage && \
			VIDCARDS="${VIDCARDS} savage.${KV_OBJ}"
		use video_cards_sis && \
			VIDCARDS="${VIDCARDS} sis.${KV_OBJ}"
		use video_cards_via && \
			VIDCARDS="${VIDCARDS} via.${KV_OBJ}"
		use video_cards_sunffb && \
			VIDCARDS="${VIDCARDS} ffb.${KV_OBJ}"
		use video_cards_tdfx && \
			VIDCARDS="${VIDCARDS} tdfx.${KV_OBJ}"
		use video_cards_nouveau && \
			VIDCARDS="${VIDCARDS} nouveau.${KV_OBJ}"
	else
		for card in ${POSSIBLE_VIDCARDS}; do
			VIDCARDS="${VIDCARDS} ${card}.${KV_OBJ}"
		done
	fi
}

die_error() {
	eerror "Portage could not build the DRM modules. If you see an ACCESS"
	eerror "DENIED error, this could mean that you were using an unsupported"
	eerror "kernel build system. Only 2.6 kernels at least as new as 2.6.6"
	eerror "are supported."
	die "Unable to build DRM modules."
}

get_drm_build_dir() {
	if kernel_is 2 6
	then
		SRC_BUILD="${S}/linux-core"
	fi
}
