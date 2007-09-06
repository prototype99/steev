# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

IUSE="hardened latin1"

MY_PV="${PV/_p/-}.0"
MY_P="${PN}-univ-${MY_PV}.i386"

DESCRIPTION="Oracle 10g Express Edition for Linux"
HOMEPAGE="http://www.oracle.com/technology/products/database/xe/index.html"
SRC_URI="latin1? ( ${MY_P/-univ/}.rpm )
		 !latin1? ( ${MY_P}.rpm )"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch"

S="${WORKDIR}"

RDEPEND=">=dev-libs/libaio-0.3.96
	sys-devel/bc
	!dev-db/oracle-instantclient-basic
	!dev-db/oracle-instantclient-jdbc
	!dev-db/oracle-instantclient-sqlplus"

DEPEND="${RDEPEND}"

ORACLEHOME="/usr/lib/oracle/xe/app/oracle/product/10.2.0/server"
ORACLE_OWNER="oraclexe"
ORACLE_GROUP="dba"
ORACLE_SID="XE"

pkg_nofetch() {
	eerror "Please go to:"
	eerror "  ${HOMEPAGE}"
	eerror "and download the Oracle 10g Express Edition package.  Put it in:"
	eerror "  ${DISTDIR}"
	eerror "after downloading it."
}

src_unpack() {
	rpm_src_unpack
}

pkg_setup() {
	if use hardened; then
		ewarn
		ewarn "Oracle-xe and hardened do not mix very well, USE AT YOUR OWN RISK!"
		ewarn
		ebeep
	fi

	einfo "checking for ${ORACLE_GROUP} group..."
	enewgroup ${ORACLE_GROUP}
	einfo "checking for ${ORACLE_OWNER} user..."
	enewuser ${ORACLE_OWNER} -1 /bin/bash /usr/lib/oracle/xe ${ORACLE_GROUP}
}

src_install() {
	mv "${WORKDIR}/usr" "${D}"

	exeinto ${ORACLEHOME}/bin
	doexe "${FILESDIR}/oracle_configure.sh"
	doinitd "${FILESDIR}/oracle-xe"

	doenvd "${FILESDIR}/99oracle"

	dosed "s:%ORACLE_HOME%:${ORACLEHOME}:g" /etc/env.d/99oracle
	dosed "s:%ORACLE_SID%:${ORACLE_SID}:g" /etc/env.d/99oracle
	dosed "s:%ORACLE_OWNER%:${ORACLE_OWNER}:g" /etc/env.d/99oracle

	# snafu... (remove; sparc binaries on a x86 are pretty useless)
	[[ -n "$(file "${D}${ORACLEHOME}/lib/hsdb_ora.so" 2>/dev/null | grep SPARC)" ]] && \
		rm -f "${D}${ORACLEHOME}/lib/hsdb_ora.so" 2>/dev/null

	# fix NULL DT_RPATH
	einfo "Fixing DT_RPATH issues..."
	TMPDIR="/ade" scanelf -XrR "${D}${ORACLEHOME}/lib" &>/dev/null
}

pkg_postinst() {
	einfo
	einfo "The Oracle 10g Express Edition Database has been installed."
	einfo
	einfo "You have to run"
	einfo "  ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "to adjust kernel parameters and"
	einfo "  ${ORACLEHOME}/bin/oracle_configure.sh"
	einfo "to configure oracle-xe before first use!"
	einfo
}

pkg_config() {
	einfo "Checking kernel parameters..."
	einfo

	# Check and Update Kernel parameters
	semmsl=`cat /proc/sys/kernel/sem | awk '{print $1}'`
	semmns=`cat /proc/sys/kernel/sem | awk '{print $2}'`
	semopm=`cat /proc/sys/kernel/sem | awk '{print $3}'`
	semmni=`cat /proc/sys/kernel/sem | awk '{print $4}'`
	shmmax=`cat /proc/sys/kernel/shmmax`
	shmmni=`cat /proc/sys/kernel/shmmni`
	shmall=`cat /proc/sys/kernel/shmall`
	filemax=`cat /proc/sys/fs/file-max`
	ip_local_port_range_lb=`cat /proc/sys/net/ipv4/ip_local_port_range | awk '{print $1}'`
	ip_local_port_range_ub=`cat /proc/sys/net/ipv4/ip_local_port_range | awk '{print $2}'`

	change=no
	if [ $semmsl -lt 250 ]; then
		semmsl=250
		change=yes
	fi

	if [ $semmns -lt 32000 ]; then
		semmns=32000
		change=yes
	fi

	if [ $semopm -lt 100 ];	then
		semopm=100
		change=yes
	fi

	if [ $semmni -lt 128 ]; then
		semmni=128
		change=yes
	fi

	if [ "$change" != "no" ]; then
		einfo "kernel.sem="$semmsl $semmns $semopm $semmni""
	fi

	if [ $shmmax -lt 536870912 ]; then
		einfo "kernel.shmmax="536870912""
		change=yes
	fi

	if [ $shmmni -lt 4096 ]; then
		einfo "kernel.shmmni="4096""
		change=yes
	fi

	if [ $shmall -lt 2097152 ]; then
		einfo "kernel.shmall="2097152""
		change=yes
	fi

	if [ $filemax -lt 65536 ]; then
		einfo "fs.file-max="65536""
		change=yes
	fi

	changeport=no
	if [ $ip_local_port_range_lb -lt 1024 ]; then
		changeport=yes
		ip_local_port_range_lb=1024
	fi

	if [ $ip_local_port_range_ub -gt 65000 ]; then
		ip_local_port_range_ub=65000
		changeport=yes
	fi

	if [ "$changeport" != "no" ]; then
		einfo "net.ipv4.ip_local_port_range="$ip_local_port_range_lb $ip_local_port_range_ub""
	fi

	if [ "$change" != "no" ] || [ "$changeport" != "no" ]; then
		einfo
		einfo "It is recommended to add the above kernel parameters to /etc/sysctl.conf:"
		einfo "After setting kernel parameters activate them using '/sbin/sysctl -p'"
	else
		einfo "Kernel parameters set, configure oracle-xe using"
		einfo "  ${ORACLEHOME}/bin/oracle_configure.sh"
	fi
}
