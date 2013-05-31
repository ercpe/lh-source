inherit eutils

DESCRIPTION="X-ray Detector Software for processing single-crystal monochromatic diffraction data recorded by the rotation method."
SRC_URI="ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS-linux_ifc_Intel+AMD.tar.gz
		 ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS_html_doc.tar.gz"
HOMEPAGE="http://wiki.j-schmitz.net/wiki/Private_Portage_Overlay"
RESTRICT="primaryuri"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="mp"
RDEPEND=""
DEPEND="${RDEPEND}"

#src_unpack() {
#	unpack XDS-linux_ifc_Intel+AMD.tar.gz
#	unpack XDS_html_doc.tar.gz
#}


src_install() {
	exeinto /opt/xray/XDS
	doexe XDS-linux_ifc_Intel+AMD/*
	dosym /opt/xray/XDS/xdsconv /usr/bin/xdsconv
	if use mp
	then
		dosym /opt/xray/XDS/xds_par /usr/bin/xds
		dosym /opt/xray/XDS/xscale_par /usr/bin/xscale
		dosym /opt/xray/XDS/xds /usr/bin/xds_single
		dosym /opt/xray/XDS/xscale /usr/bin/xscale_single
	else
		dosym /opt/xray/XDS/xds_par /usr/bin/xds_par
		dosym /opt/xray/XDS/xscale_par /usr/bin/xscale_par
		dosym /opt/xray/XDS/xds /usr/bin/xds
		dosym /opt/xray/XDS/xscale /usr/bin/xscale
	fi
	dohtml -r XDS_html_doc/*
	dodoc XDS_html_doc/html_doc/INPUT_templates/*
}

pkg_postinst(){
	einfo "his package will expire at"
	einfo "Expiration date: June 30, 2008"
}

