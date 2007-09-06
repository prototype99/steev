# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono gnome2 eutils

DESCRIPTION="Evolution# is a .NET language binding for various Evolution (tm) libraries"
HOMEPAGE="http://ximian.com/products/evolution/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="doc"
RESTRICT="nomirror"

RDEPEND=">=gnome-extra/evolution-data-server-1.4
	>=mail-client/evolution-2.2
	>=dev-lang/mono-1.0
	>=dev-dotnet/gtk-sharp-1.9.5
	>=gnome-extra/gtkhtml-3.0.10
	>=gnome-base/orbit-2.9.8"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog INSTALL MAINTAINERS NEWS README"

src_unpack() {
	unpack ${A}
	cd ${S}

	### Fix for new evolution-shell pkgconfig file, not going upstream
	epatch ${FILESDIR}/${P}-evo28.patch

	autoconf || die "Autoconf failed"
}
