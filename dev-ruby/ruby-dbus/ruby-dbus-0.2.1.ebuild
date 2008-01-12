# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

DESCRIPTION="Ruby implementation of D-Bus"
HOMEPAGE="https://trac.luon.net/ruby-dbus/"
SRC_URI="https://trac.luon.net/data/ruby-dbus/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="tutorial"

RDEPEND=""
DEPEND="${RDEPEND}
	tutorial? ( app-text/webgen )"
