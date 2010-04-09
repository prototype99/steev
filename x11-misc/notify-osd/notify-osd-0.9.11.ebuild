# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

#MY_P="notify_osd-${PV}"
EAPI=0

DESCRIPTION="daemon that displays passive pop-up notifications"
HOMEPAGE="https://launchpad.net/notify-osd"

SRC_URI="http://launchpad.net/notify-osd/trunk/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~arm ~x86"
RDEPEND="!x11-misc/notification-daemon
	sys-apps/dbus
	x11-libs/libnotify
	>=x11-libs/gtk+-2.14"
DEPEND="${RDEPEND}"