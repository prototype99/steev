# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils toolchain-funcs multilib mono autotools perl-app gnome2

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://www.pidgin.im"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

PROTOCOL_IUSE="bonjour gadu irc jabber msn novell qq sametime silc simple yahoo zephyr"
IUSE="X console dbus debug doc eds gnutls gstreamer kerberos mono networkmanager perl predict sasl spell ssl static startup-notification tcl test tk xscreensaver $PROTOCOL_IUSE"

RDEPEND=">=dev-libs/glib-2.0
		 >=gnome-base/gconf-2
		 >=dev-libs/libxml2-2.6
		 X? (
		 		>=x11-libs/gtk+-2
				>=x11-libs/pango-1.4
				eds? ( gnome-extra/evolution-data-server )
				predict? ( >=dev-db/sqlite-3.3 )
				spell? ( >=app-text/gtkspell-2.0.2 )
				startup-notification? ( >=x11-libs/startup-notification-0.5 )
				xscreensaver? ( x11-libs/libXext x11-libs/libXScrnSaver )
			)
		 !X? ( sys-libs/ncurses )
		 console? ( sys-libs/ncurses )
		 dbus?	(
					>=dev-libs/dbus-glib-0.71
					networkmanager? ( net-misc/networkmanager )
				)
		 gstreamer? ( >=media-libs/gstreamer-0.10 >=media-libs/gst-plugins-good-0.10 )
		 kerberos? ( >=app-crypt/mit-krb5-1.3.6-r1 )
		 mono? ( dev-lang/mono )
		 perl? ( >=dev-lang/perl-5.8.2-r1 !<perl-core/ExtUtils-MakeMaker-6.17 )
		 sasl? ( >=dev-libs/cyrus-sasl-2 )
		 ssl? 	(
					gnutls? ( net-libs/gnutls )
					!gnutls? ( >=dev-libs/nss-3.11 )
		 		)
		 tcl? ( dev-lang/tcl )
		 tk? ( dev-lang/tk )

		 bonjour? ( net-dns/avahi )
		 gadu? ( net-libs/libgadu )
		 msn?	(
		 			gnutls? ( net-libs/gnutls )
					!gnutls? ( >=dev-libs/nss-3.11 )
				)
		 sametime? ( =net-libs/meanwhile-1* )
		 silc? ( >=net-im/silc-toolkit-0.9.12-r3 )"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9
		>=sys-devel/gettext-0.10.14
		dbus? ( >=dev-lang/python-2.4 )
		doc? ( app-doc/doxygen )
		test? ( >=dev-libs/check-0.94 )"

DOCS="AUTHORS HACKING NEWS PROGRAMMING_NOTES README ChangeLog"

MAKEOPTS="${MAKEOPTS} -j1"

# Enable only the AIM protocol by default
DYNAMIC_PRPLS="oscar"

pkg_setup() {
	if ! use X && ! use ncurses ; then
		ewarn "You have not selected an interface, we will default to ncurses"
		ebeep 5
	fi

	if ! use X ; then
		if use eds ; then
			ewarn "Evolution support requires the GTK+ UI"
			die "eds requires X"
		fi

		if use predict ; then
			ewarn "Contact Availablity Prediction requires the GTK+ UI"
			die "predict requires X"
		fi

		if use spell ; then
			ewarn "Spell checking requires the GTK+ UI"
			die "spell requires X"
		fi

		if use startup-notification ; then
			ewarn "Startup notification requires the GTK+ UI"
			die "startup-notification requires X"
		fi

		if use xscreensaver ; then
			ewarn "Screensaver support requires the GTK+ UI"
			die "xscreensaver requires X"
		fi
	fi

	if ! use dbus ; then
		if use networkmanager ; then
			ewarn "Network Manager support requires DBus"
			die "networkmanager requires dbus"
		fi
	fi

	if use bonjour ; then
		if ! built_with_use 'net-dns/avahi' 'howl-compat' ; then
			eerror
			eerror "You must build avahi with howl compatibility."
			eerror "echo \"net-dns/avahi howl-compat\" >> /etc/portage/package.use"
			eerror "emerge --oneshot avahi"
			eerror
			ebeep 5
			die "Howl compatibility required for avahi."
		fi
	fi

	if use gadu ; then
		if built_with_use 'net-libs/libgadu' 'ssl' ; then
			eerror
			eerror "You must build libgadu without ssl support."
			eerror "echo \"net-libs/libgadu -ssl\" >> /etc/portage/package.use"
			eerror "emerge --oneshot libgadu"
			eerror
			ebeep 5
			die "libgadu requires -ssl"
		fi
	fi

	if use msn && ! use ssl ; then
		ewarn "MSN support requires SSL"
		die "msn requires ssl"
	fi

	if use kerberos && ! built_with_use 'app-crypt/mit-krb5' 'krb4' ; then
		eerror
		eerror "You must build mit-krb5 with kerberos 4 support for zephyr"
		eerror "echo \"app-crypt/mit-krb5 krb4\" >> /etc/portage/package.use"
		eerror "emerge mit-krb5"
		eerror
		die "Kerberos support requested with no kerberos support in mit-krb5."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/pidgin-2.0.0.patch
}

src_compile() {
	# Stabilize things, for your own good
	strip-flags
	replace-flags -O? -O2

	local myconf="--enable-libxml --with-howl-includes=/usr/include/avahi-compat-howl"

	if use bonjour ; then
		einfo "Enabling bonjour support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,bonjour"
	else
		einfo "Disabling bonjour support"
		myconf="${myconf} --with-howl-includes=."
		myconf="${myconf} --with-howl-libs=."
	fi

	if use gadu ; then
		einfo "Enabling gadu gadu support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,gg"
	else
		einfo "Disabling gadu gadu support"
	fi

	if use irc ; then
		einfo "Enabling IRC support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,irc"
	else
		einfo "Disabling IRC support"
	fi

	if use jabber ; then
		einfo "Enabling Jabber support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,jabber"
	else
		einfo "Disabling Jabber support"
	fi

	if use msn ; then
		einfo "Enabling MSN support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,msn"
	else
		einfo "Disabling MSN support"
	fi

	if use novell ; then
		einfo "Enabling Novell support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,novell"
	else
		einfo "Disabling Novell support"
	fi

	if use qq ; then
		einfo "Enabling qq support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,qq"
	else
		einfo "Disabling qq support"
	fi

	if use sametime ; then
		einfo "Enabling sametime support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,sametime"
	else
		einfo "Disabling sametime support"
	fi

	if use silc ; then
		einfo "Enabling SILC support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,silc"
	else
		einfo "Disabling SILC support"
		myconf="${myconf} --with-silc-includes=."
		myconf="${myconf} --with-silc-libs=."
	fi

	if use simple ; then
		einfo "Enabling Simple support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,simple"
	else
		einfo "Disabling Simple support"
	fi

	if use yahoo ; then
		einfo "Enabling Yahoo support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,yahoo"
	else
		einfo "Disabling Yahoo support"
	fi

	if use zephyr ; then
		einfo "Enabling Zephyr support"
		DYNAMIC_PRPLS="$DYNAMIC_PRPLS,zephyr"
	else
		einfo "Disabling zephyr support"
	fi

	if use ssl ; then
		if use gnutls ; then
			einfo "Disabling NSS, using GnuTLS"
			myconf="${myconf} --enable-nss=no"
			myconf="${myconf} --with-gnutls-includes=/usr/include/gnutls"
			myconf="${myconf} --with-gnutls-libs=/usr/$(get_libdir)"
		else
			einfo "Disabling GnuTLS, using NSS"
			myconf="${myconf} --enable-gnutls=no"
		fi
	else
		einfo "Disabling SSL Support"
		myconf="${myconf} --enable-gnutls=no --enable-nss=no"
		if use jabber ; then
			ewarn "Google Talk will not work unless you build with SSL support"
		fi
	fi

	if use X ; then
		myconf="${myconf} --enable-gtkui"
		myconf="${myconf} $(use_enable console consoleui)"
	else
		myconf="${myconf} --enable-consoleui"
	fi

	if use xscreensaver ; then
		myconf="${myconf} --x-includes=/usr/include/X11"
	fi

	econf $(use_enable dbus) \
		  $(use_enable debug) \
		  $(use_enable debug fatal-asserts) \
		  $(use_enable doc doxygen) \
		  $(use_enable doc dot) \
		  $(use_enable eds gevolution) \
		  $(use_enable gnutls) \
		  $(use_enable !gnutls nss) \
		  $(use_enable gstreamer) \
		  $(use_enable mono) \
		  $(use_enable networkmanager nm) \
		  $(use_enable perl) \
		  $(use_enable predict cap) \
		  $(use_enable sasl cyrus-sasl) \
		  $(use_enable spell gtkspell) \
		  $(use_enable startup-notification) \
		  $(use_enable static prpls) \
		  $(use_enable tcl) \
		  $(use_enable tk) \
		  $(use_enable xscreensaver screensaver) \
		  $(use_with kerberos krb4) \
		  "--with-dynamic-prpls=${DYNAMIC_PRPLS}" \
		  ${myconf} || die "Configuration failed"

	emake || die "Make failed"
}

src_install() {
	gnome2_src_install

	use perl && fixlocalpod
	dodoc AUTHORS HACKING NEWS PROGRAMMING_NOTES README ChangeLog
}
