# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vcscommand/vcscommand-0.1_beta19.ebuild,v 1.1 2007/09/06 13:02:41 hawking Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: CVS/SVN/SVK integration plugin"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=90"

LICENSE="public-domain"
KEYWORDS="~x86"
IUSE="cvs git subversion svk"

RDEPEND="cvs? ( dev-util/cvs )
	subversion? ( dev-util/subversion )
	svk? ( dev-util/svk )
	git? ( dev-util/git )
	!app-vim/cvscommand
	!app-vim/calendar" # conflict, bug 62677

VIM_PLUGIN_HELPFILES="vcscommand"

no_flags_die() {
	eerror "Please choose at least one VCS system"
	eerror "to be supported by this plugin."
	die "No vcs systems set"
}

pkg_setup() {
	elog "Note:	Support for all VCS systems are enabled by use flags."
	elog "		Make sure you've enabled the flags you want."

	use cvs || use git || use subversion || use svk || no_flags_die
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	use cvs || rm syntax/CVSAnnotate.vim plugin/vcscvs.vim
	use git || rm plugin/vcsgit.vim
	use subversion || rm syntax/SVNAnnotate.vim plugin/vcssvn.vim
	use svk || rm syntax/SVKAnnotate.vim plugin/vcssvk.vim
}
