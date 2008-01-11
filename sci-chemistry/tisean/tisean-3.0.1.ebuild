# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/shelx/shelx-20060317.ebuild,v 1.6 2007/03/15 21:49:56 kugelfang Exp $

inherit autotools eutils fortran
MY_P="Tisean_3.0.1"
DESCRIPTION="A software project for the analysis of time series with methods based on the theory of nonlinear deterministic dynamical systems."
HOMEPAGE="http://www.mpipks-dresden.mpg.de/%7Etisean/Tisean_3.0.1/index.html"
SRC_URI="http://www.mpipks-dresden.mpg.de/~tisean/TISEAN_3.0.1.tar.gz"
RESTRICT=""
LICENSE="gpl-v2"
SLOT="0"
KEYWORDS="x86"
IUSE="gnuplot"
RDEPEND="gnuplot? ( gnuplot )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

#src_unpack() {
#	unpack ${A}
#	epatch "${FILESDIR}/configure.patch"
#}

pkg_setup() {
        FORTRAN="g77 gfortran ifort"
        fortran_pkg_setup
        if  [[ ${FORTRANC} == if* ]]; then
                ewarn "Using Intel Fortran at your own risk"
        fi
}

src_compile() {
	export FC=$FORTRANC
	econf \
	--prefix=${D}"usr"
#		FC="ifort" \
#		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	dodir /usr/bin
	emake install || die "install failed"
}