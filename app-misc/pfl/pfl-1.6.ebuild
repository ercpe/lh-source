# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $



SLOT=""
LICENSE="GPLv2"
KEYWORDS="~x86 ~amd64"
DESCRIPTION="PFL is an online searchable file/package database for Gentoo"
SRC_URI="http://files.portagefilelist.de/pfl"
HOMEPAGE="http://www.portagefilelist.de/index.php/Special:PFLQuery"
IUSE=""
RESTRICT="mirror"

DEPEND="mp? ( app-arch/pbzip2 )"


src_unpack(){
	cp "${DISTDIR}/pfl" ${WORKDIR}/pfl.py
}

src_install(){

cat >> "${T}/pfl" << EOF
#!/bin/sh

exec nice ${python} /usr/lib/pfl/pfl.py

EOF
	
	exeinto /etc/cron.daily/
	doexe "${T}/pfl"
	
	insinto /usr/lib/pfl/
	doins pfl.py
}