# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop/monodevelop-0.12.ebuild,v 1.3 2006/12/11 01:03:43 compnerd Exp $

inherit mono eutils fdo-mime

DESCRIPTION="Free .NET development environment"
SRC_URI="http://www.go-mono.com/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://monodevelop.com/"
LICENSE="GPL-2"

IUSE="boo java nemerle subversion"
DEPEND=">=dev-dotnet/gtksourceview-sharp-0.10
	>=dev-dotnet/gecko-sharp-0.10
	>=dev-lang/mono-1.1.10
	>=dev-util/monodoc-1.0
	>=dev-dotnet/gtk-sharp-2.4.0
	>=dev-dotnet/gnomevfs-sharp-2.4.0
	>=dev-dotnet/gnome-sharp-2.4.0
	>=dev-dotnet/gconf-sharp-2.4.0
	>=dev-dotnet/gtkhtml-sharp-2.4.0
	>=dev-dotnet/glade-sharp-2.4.0
	x11-wm/metacity
	boo? ( >=dev-lang/boo-0.7.6 )
	java? ( || ( >=dev-dotnet/ikvm-bin-0.14 >=dev-dotnet/ikvm-0.14.0.1-r1 ) )
	nemerle? ( >=dev-lang/nemerle-0.9.3.99 )
	subversion? ( dev-util/subversion )"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.14-fixes.diff
}

src_compile() {
	econf \
		$(use_enable boo) \
		$(use_enable java) \
		$(use_enable nemerle) \
		$(use_enable subversion) \
		--enable-nunit \
		--enable-versioncontrol \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		|| die
	emake -j1 || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
