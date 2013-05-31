inherit eutils

DESCRIPTION="HKL2MAP is a graphical user-interface for macromolecular phasing."
SRC_URI="${P}.tgz"
HOMEPAGE="http://schneider.group.ifom-ieo-campus.it/hkl2map/index.html"
RESTRICT="mirror fetch"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="script"
	if use script;then
		SRC_URI="$SRC_URI http://schneider.group.ifom-ieo-campus.it/hkl2map/phs2mtz"
	fi
RDEPEND="sci-chemistry/shelx
		 >=dev-lang/tk-8.3
		 >=dev-lang/tcl-8.3
		 script? ( sci-chemistry/ccp4 )"
DEPEND="${RDEPEND}"

pkg_nofetch(){
        einfo "Please visit:"
        einfo "\thttp://schneider.group.ifom-ieo-campus.it/hkl2map/index.html"
        einfo
        einfo "Complete the registration process, then download the following files:"
        einfo "\t${A}"
        einfo
        einfo "Place the downloaded files in your distfiles directory:"
        einfo "\t${DISTDIR}"
}

src_install() {
	exeinto "/usr/bin"
	newexe hkl2map-0.2-dist hkl2map
	if use script;then
		doexe phs2mtz
	fi
}

pkg_postinst(){
	echo
	einfo "If you use HKL2MAP in you work, please cite the following publication:"
	echo
	einfo "Thomas Pape & Thomas R. Schneider"
	einfo "HKL2MAP: a graphical user interface for phasing with SHELX programs"
	einfo "J. Appl. Cryst. 37:843-844 (2004)."
	echo
}
