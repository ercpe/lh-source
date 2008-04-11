# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $



SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="-* ~x86 ~amd64"
DESCRIPTION="The tools package from USF for macromolecular crystallography"
SRC_URI="ftp://xray.bmc.uu.se/pub/gerard/xutil/xutil_linux.tar.gz
		 ftp://xray.bmc.uu.se/pub/gerard/xutil/xutil_etc.tar.gz"
HOMEPAGE="http://alpha2.bmc.uu.se/usf/xutil.html"
IUSE=""
RESTRICT="mirror"

src_install(){
	exeinto /opt/${PN}
	for i in `ls xutil_linux`
	do
		newexe xutil_linux/$i ${i#lx_}
	done
	insinto /opt/usf-lib
	doins xutil_etc/*lib
	dodoc xutil_etc/*doc

	cat>>"${T}"/20${PN}<<-EOF
	PATH="/opt/${PN}/"
	GKLIB="/opt/usf-lib/"
	EOF
	doenvd "${T}"/20${PN}
}