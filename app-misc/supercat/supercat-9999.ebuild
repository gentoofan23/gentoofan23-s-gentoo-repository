# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/supercat/supercat-0.5.2.ebuild,v 1.1 2007/09/29 00:23:14 tester Exp $

inherit subversion

DESCRIPTION="A text file colorizer using powerful regular expressions"
HOMEPAGE="http://supercat.nosredna.net"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

ESVN_REPO_URI="svn://192.168.1.10/supercat/trunk"
ESVN_BOOSTRAP="./autogen.sh"

src_compile() {
	./autogen.sh

	econf
	emake
	
}
src_install() {
	emake DESTDIR=${D} install || die "Install failed!"

	dodoc ChangeLog
}
