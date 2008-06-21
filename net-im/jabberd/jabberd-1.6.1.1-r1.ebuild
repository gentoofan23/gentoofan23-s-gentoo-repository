# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/jabberd/jabberd-1.6.1.1-r1.ebuild,v 1.3 2008/06/20 19:32:42 gentoofan23 Exp $

WANT_AUTOMAKE="1.9"
inherit autotools eutils

DESCRIPTION="Open-source Jabber server"
HOMEPAGE="http://www.jabber.org"
SRC_URI="http://download.jabberd.org/jabberd14/jabberd14-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="ipv6 mysql postgres"

RDEPEND=">=net-im/jabber-base-0.01
	>=dev-libs/pth-1.4.0
	dev-libs/expat
	net-dns/libidn
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )
	net-libs/gnutls
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!net-im/jabberd2"

S=${WORKDIR}/jabberd14-${PV}

pkg_setup() {
	if use ipv6; then
		ewarn "Without full ipv6 support, jabberd will show the error:"
		ewarn '   "mio unable to listen"'
		ewarn "To fix this, emerge jabberd without the ipv6 USE flag."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#Shamelessly stolen from Freebsd
	epatch "${FILESDIR}/${P}-gnutls2.2.patch"
	## Gentoo bug #200616
	epatch "${FILESDIR}/${P}-sandbox.patch"
	epatch "${FILESDIR}/${P}-parallel-make.patch"
	epatch "${FILESDIR}/${P}-undefineddebug.patch"

	eautoreconf || die "Reconfiguring autotools failed!"
}

src_compile() {
	unset LC_ALL LC_CTYPE

	econf \
		--sysconfdir=/etc/jabber \
		--enable-ssl \
		$(use_enable ipv6) \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	newinitd "${FILESDIR}"/${P}.init jabber || die "newinitd failed"

	# net-im/jabber-base provides needed directories
	rm -rf "${D}/var"
	mv "${D}/etc/jabber/jabber.xml" "${D}/etc/jabber/jabberd.xml"
	mv "${D}/etc/jabber/jabber.xml.dist" "${D}/etc/jabber/jabberd.xml.dist"

	sed -i \
		-e 's,/var/lib/spool/jabberd,/var/spool/jabber,g' \
		-e 's,/var/lib/log/jabberd,/var/log/jabber,g' \
		-e 's,/var/lib/run/jabberd,/var/run/jabber,g' \
		-e 's,jabber.pid,jabberd14.pid,g' \
		"${D}"/etc/jabber/jabberd.xml{,.dist} \
		|| die "sed failed"

}

pkg_postinst() {

	echo
	elog 'The various IM transports for jabber are now separate packages,'
	elog 'which you will need to install separately if you want them:'
	elog '   net-im/jit - ICQ transport'
	elog '   net-im/pymsn-t - MSN transport'
	elog '   net-im/jud - Jabber User Directory'
	elog '   net-im/yahoo-transport - Yahoo IM system'
	elog '   net-im/mu-conference - Jabber multi user conference'
	echo
	ewarn 'If upgrading from an older version, please stop jabberd BEFORE'
	ewarn 'updating the init.d script, or you will end with a "dead" server.'
	ewarn
	ewarn 'The configuration filename has changed:'
	ewarn '   Configure your server in /etc/jabber/jabberd.xml'
	echo
	ebeep

}
