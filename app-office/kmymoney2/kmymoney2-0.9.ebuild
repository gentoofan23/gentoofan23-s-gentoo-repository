# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney2/kmymoney2-0.9.ebuild,v 1.1 2008/07/03 00:40:09 keytoaster Exp $

EAPI="1"
inherit kde

DESCRIPTION="Personal Finances Manager for KDE."
HOMEPAGE="http://kmymoney2.sourceforge.net"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt ofx qtdesigner test"

COMMON_DEPEND="dev-libs/libxml2
	hbci? ( >=net-libs/aqbanking-1.8.0_beta )
	ofx? ( >=dev-libs/libofx-0.8.2
	|| ( dev-cpp/xmlpp:2.6 >=dev-cpp/libxmlpp-1.0.1:0 )
	>=net-misc/curl-7.9.7
	app-text/opensp )"

DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.9.0
	test? ( >=dev-util/cppunit-1.8.0 )"

RDEPEND="${COMMON_DEPEND}
	crypt? ( app-crypt/gnupg )"

need-kde 3.5

src_unpack() {
	kde_src_unpack

	cd "${S}"/kmymoney2/widgets
	for x in Makefile.am Makefile.in; do
		sed -e "s/kmymoneytitlelabel.png//" -i ${x}
	done
}

src_compile() {
	local myconf="$(use_enable ofx ofxplugin)
		$(use_enable ofx ofxbanking)
		$(use_enable qtdesigner)
		$(use_enable test cppunit)"

	# bug 132665
	replace-flags "-Os" "-O2"

	kde_src_compile
}

src_test() {
	# Parallel make check is broken
	make -j1 check || die "Make check failed!"
}

src_install() {
	kde_src_install
	# bug 139082
	rm "${D}"/usr/bin/kmymoney
}
