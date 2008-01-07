inherit flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="OpenRC manages the services, startup and shutdown of a host"
HOMEPAGE="http://roy.marples.name/"

if [ "${PV}" = "9999" ]; then
inherit git
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/openrc.git"
else
SRC_URI="http://roy.marples.name/${P}.tar.bz2"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="ncurses pam static unicode kernel_linux kernel_FreeBSD"

RDEPEND="virtual/init
 		kernel_linux? (
			>=sys-apps/coreutils-5.2.1
			>=sys-apps/module-init-tools-3.2.2-r2
			sys-apps/makedev
		)
		kernel_FreeBSD? ( sys-process/fuser-bsd )
		ncurses? ( sys-libs/ncurses )
		pam? ( virtual/pam )
		!<sys-apps/baselayout-2.0.0"
DEPEND="virtual/os-headers"

pkg_setup() {
	LIBDIR="lib"
	[ "${SYMLINK_LIB}" = "yes" ] && LIBDIR=$(get_abi_LIBDIR "${DEFAULT_ABI}")
	
	MAKE_ARGS="${MAKE_ARGS} LIBNAME=${LIBDIR}"

	local brand="Unknown"
	if use kernel_linux; then
		MAKE_ARGS="${MAKE_ARGS} OS=Linux"
		brand="Linux"
	else
		MAKE_ARGS="${MAKE_ARGS} OS=BSD"
		use kernel_FreeBSD && brand="FreeBSD"
	fi
	[ -n "${brand}" ] && MAKE_ARGS="${MAKE_ARGS} BRANDING=Gentoo/${brand}"

	use ncurses && MAKE_ARGS="${MAKE_ARGS} TERMCAP=ncurses"
	if use pam; then
		MAKE_ARGS="${MAKE_ARGS} PAM=pam"
		if use static; then
			ewarn "OpenRC cannot be built statically with PAM"
			elog "not building statically"
		fi
	fi
	if use static && ! use pam; then
		if use elibc_glibc; then
			MAKE_ARGS="${MAKE_ARG} PROGLDFLAGS=-Wl,-Bstatic"
		else
			MAKE_ARGS="${MAKE_ARGS} PROGLDFLAGS=-static"
		fi
	fi

	MAKE_ARGS="${MAKE_ARGS} CC=$(tc-getCC)"
}

src_compile() {
	emake ${MAKE_ARGS} || die
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install || die

	# Backup our default runlevels
	dodir /usr/share/"${PN}"
	mv "${D}/etc/runlevels" "${D}/usr/share/${PN}"

	# Setup unicode defaults for silly unicode users
	if use unicode; then
		sed -i -e '/^unicode=/s:NO:YES:' "${D}"/etc/rc.conf
	fi

	# Fix portage bitching about libs and symlinks
	rm "${D}"/usr/"${LIBDIR}"/libeinfo.so
	rm "${D}"/usr/"${LIBDIR}"/librc.so
	ln -s libeinfo.so.1 "${D}"/"${LIBDIR}"/libeinfo.so
	ln -s librc.so.1 "${D}"/"${LIBDIR}"/librc.so
	gen_usr_ldscript libeinfo.so
	gen_usr_ldscript librc.so
}

pkg_preinst() {
	# baselayout bootmisc init script has been split out in OpenRC
	# so handle upgraders
	if ! has_version sys-apps/openrc; then
		local x= xtra=
		use kernel_linux && xtra="${xtra} procfs sysctl"
		use kernel_FreeBSD && xtra="${xtra} savecore dumpon"
		for x in swap ${xtra}; do
			[ -e "${ROOT}"etc/runlevels/boot/"${x}" ] && continue
			ln -snf /etc/init.d/"${x}" "${ROOT}"etc/runlevels/boot/"${x}"
		done
	fi

	# Upgrade out state for baselayout-1 users
	if [ ! -e "${ROOT}${LIBDIR}"/rc/init.d/started ]; then 
		(
		[ -e "${ROOT}"etc/conf.d/rc ] && . "${ROOT}etc/conf.d/rc"
		svcdir=${svcdir:-/var/lib/init.d}
		if [ ! -d "${ROOT}${svcdir}/started" ]; then
			ewarn "No state found, and no state exists"
			elog "You should reboot this host"
		else
			einfo "Moving state from ${ROOT}${svcdir} to ${ROOT}${LIBDIR}/rc/init.d"
			mv "${ROOT}${svcdir}"/* "${ROOT}${LIBDIR}"/rc/init.d
			rm -rf "${ROOT}${LIBDIR}"/rc/init.d/daemons \
				"${ROOT}${LIBDIR}"/rc/init.d/console
			umount "${ROOT}${svcdir}" 2>/dev/null
			rm -rf "${ROOT}${svcdir}"
		fi
		)
	fi
}

pkg_postinst() {
	# Make our runlevels if they don't exist
	if [ ! -e "${ROOT}"etc/runlevels ]; then
		einfo "Copying across default runlevels"
		cp -RPp "${ROOT}"usr/share/"${PN}"/runlevels "${ROOT}"/etc
	fi

	if [ -d "${ROOT}"etc/modules.autoload.d ]; then
		ewarn "${ROOT}etc/modules.autoload.d exists"
		ewarn "This has been deprecated in favour of /etc/conf.d/modules"
	fi

	einfo "You should now update all files in /etc, using etc-update"
	einfo "or equivalent before restarting any services or this host."
}