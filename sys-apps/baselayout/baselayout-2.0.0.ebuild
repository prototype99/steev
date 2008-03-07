inherit flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="Filesystem baselayout and init scripts"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://roy.marples.name/~roy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="bootstrap build kernel_linux kernel_FreeBSD"

PDEPEND="sys-apps/openrc"
RDEPEND="!<net-misc/dhcpcd-2.0.0
		!<sys-apps/baselayout-2.0.0"
DEPEND="virtual/os-headers"
PROVIDE="virtual/baselayout"

make_opts() {
	local libdir="lib"
	[ "${SYMLINK_LIB}" = "yes" ] && libdir=$(get_abi_LIBDIR "${DEFAULT_ABI}")
	echo "LIB=${libdir}"
}

pkg_preinst() {
	# We need to install directories and maybe some dev nodes when building
	# stages, but they cannot be in CONTENTS.
	# Also, we cannot reference $S as binpkg will break so we do this.
	if use build || use bootstrap ; then
		local libdirs="$(get_all_libdirs)" dir=
		# Create our multilib dirs - the Makefile has no knowledge of this
		: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...
		for dir in ${libdirs}; do
			mkdir -p "${ROOT}${dir}"
			touch "${ROOT}${dir}"/.keep
			mkdir -p "${ROOT}usr/${dir}"
			touch "${ROOT}usr/${dir}"/.keep
			mkdir -p "${ROOT}usr/local/${dir}"
			touch "${ROOT}usr/local/${dir}"/.keep
		done

		# Ugly compatibility with stupid ebuilds and old profiles symlinks
		if [ "${SYMLINK_LIB}" = "yes" ] ; then
			rm -r "${ROOT}"/{lib,usr/lib,usr/local/lib} 2>/dev/null
			local lib=$(get_abi_LIBDIR ${DEFAULT_ABI})
			ln -s "${lib}" "${ROOT}lib"
			ln -s "${lib}" "${ROOT}usr/lib"
			ln -s "${lib}" "${ROOT}usr/local/lib"
		fi

		emake -C "${T}" $(make_opts) DESTDIR="${ROOT}" layout || die "failed to layout filesystem"
	fi
}

src_install() {
	emake $(make_opts) DESTDIR="${D}" install || die
	dodoc ChangeLog COPYRIGHT

	# Should this belong in another ebuild? Like say binutils?
	# List all the multilib libdirs in /etc/env/04multilib (only if they're
	# actually different from the normal
	if has_multilib_profile || [ $(get_libdir) != "lib" -o -n "${CONF_MULTILIBDIR}" ]; then
		local libdirs="$(get_all_libdirs)" libdirs_env= dir=
		: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...
		for dir in ${libdirs}; do
			libdirs_env=${libdirs_env:+$libdirs_env:}/${dir}:/usr/${dir}:/usr/local/${dir}
		done

		# Special-case uglyness... For people updating from lib32 -> lib amd64
		# profiles, keep lib32 in the search path while it's around
		if has_multilib_profile && [ -d "${ROOT}"lib32 -o -d "${ROOT}"lib32 ] && ! hasq lib32 ${libdirs}; then
			libdirs_env="${libdirs_env}:/lib32:/usr/lib32:/usr/local/lib32"
		fi
		echo "LDPATH=\"${libdirs_env}\"" > "${T}"/04multilib
		doenvd "${T}"/04multilib
	fi

	# version for testing of features that *should* be present
	echo "Gentoo Base System release ${PV}" > "${D}"/etc/gentoo-release
}

pkg_postinst() {
	# We installed some files to /usr/share/baselayout instead of /etc to stop
	# (1) overwriting the user's settings
	# (2) screwing things up when attempting to merge files
	# (3) accidentally packaging up personal files with quickpkg
	# If they don't exist then we install them
	for x in master.passwd passwd shadow group fstab ; do
		[ -e "${ROOT}etc/${x}" ] && continue
		[ -e "${ROOT}usr/share/baselayout/${x}" ] || continue
		cp -p "${ROOT}usr/share/baselayout/${x}" "${ROOT}"etc
	done

	# This is also written in src_install (so it's in CONTENTS), but
	# write it here so that the new version is immediately in the file
	# (without waiting for the user to do etc-update)
	rm -f "${ROOT}"/etc/._cfg????_gentoo-release
	local release="${PV}"
	[ "${PR}" != r0 ] && release="${release}-${PR}"
	echo "Gentoo Base System release ${release}" > "${ROOT}"/etc/gentoo-release

	# whine about users that lack passwords #193541
	if [ -e "${ROOT}"/etc/shadow ]; then
		local bad_users=$(sed -n '/^[^:]*::/s|^\([^:]*\)::.*|\1|p' "${ROOT}"/etc/shadow)
		if [ -n "${bad_users}" ] ; then
			echo
			ewarn "The following users lack passwords!"
			ewarn ${bad_users}
		fi
	fi
}
