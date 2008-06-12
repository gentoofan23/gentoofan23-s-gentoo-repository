# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney2/kmymoney2-0.8.8.ebuild,v 1.5 2008/01/24 22:38:09 philantrop Exp $

inherit kde

DESCRIPTION="Personal Finances Manager for KDE."
HOMEPAGE="http://kmymoney2.sourceforge.net"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt hbci ofx test"

COMMON_DEPEND="dev-libs/libxml2
	hbci? ( >=net-libs/aqbanking-1.8.0_beta )
	ofx? ( >=dev-libs/libofx-0.7 )"

DEPEND="${COMMON_DEPEND}
	test? ( >=dev-util/cppunit-1.8.0 )"

RDEPEND="${COMMON_DEPEND}
	crypt? ( app-crypt/gnupg )"

need-kde 3.5

pkg_setup() {
	if use hbci && ! built_with_use net-libs/aqbanking kde; then
		eerror "The HBCI plugin is shipped by net-libs/aqbanking,"
		eerror "which has to be built with KDE support."
		die "rebuild net-libs/aqbanking with USE=kde"
	fi
}

src_compile() {
	local myconf="$(use_enable ofx ofxplugin)
			$(use_enable hbci kbanking)
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
