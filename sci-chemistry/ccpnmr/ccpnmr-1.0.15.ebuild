# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs distutils multilib

SLOT=""
LICENSE="CCPN license"
KEYWORDS="~x86"
DESCRIPTION="The Collaborative Computing Project for NMR is a public non-profit project serving the macromolecular NMR community"
SRC_URI="ftp://www.bio.cam.ac.uk/pub/ccpnmr/analysis1.0.15.tar.gz"
HOMEPAGE="http://www.ccpn.ac.uk/ccpn"
IUSE=""
RESTRICT="mirror"
DEPEND="${RDEPEND}"
RDEPEND=">=dev-lang/python-2.4
		  virtual/glut
		  >=dev-lang/tcl-8.3
		  >=dev-lang/tk-8.3
		  dev-tcltk/tix
		  x11-apps/mesa-progs"

src_unpack(){
	unpack "${A}"
	epatch "${FILESDIR}/gentoo-PYTHONPATH.patch"
}



src_compile(){
	cd ccpnmr/ccpnmr1.0/c
	
	echo "CC = "$(tc-getCC)>environment.txt

cat >> environment.txt << EOF
MALLOC_FLAG = -DDO_NOT_HAVE_MALLOC
FPIC_FLAG = -fPIC
XOR_FLAG = 
IGNORE_GL_FLAG = 
GL_FLAG = -DUSE_GL_FALSE
GLUT_NEED_INIT = -DNEED_GLUT_INIT
GLUT_NOT_IN_GL = 
GLUT_FLAG = \$(GLUT_NEED_INIT) \$(GLUT_NOT_IN_GL)
SHARED_FLAGS = -shared
MATH_LIB = -lm
X11_DIR = /usr/
X11_LIB = -lX11 -lXext
X11_INCLUDE_FLAGS = -I\$(X11_DIR)/include
X11_LIB_FLAGS = -L\$(X11_DIR)/lib
TCL_DIR = /usr
TCL_LIB = -ltcl8.4
TCL_INCLUDE_FLAGS = -I\$(TCL_DIR)/include
TCL_LIB_FLAGS = -L\$(TCL_DIR)/lib
TK_DIR = /usr
TK_LIB = -ltk8.4
TK_INCLUDE_FLAGS = -I\$(TK_DIR)/include
TK_LIB_FLAGS = -L\$(TK_DIR)/lib
PYTHON_DIR = /usr
PYTHON_INCLUDE_FLAGS = -I\$(PYTHON_DIR)/include/python2.4
GL_DIR = /usr
GL_LIB = -lglut -lGLU -lGL
GL_INCLUDE_FLAGS = -I\$(GL_DIR)/include 
GL_LIB_FLAGS = -L\$(GL_DIR)/lib 
EOF
	echo "CFLAGS = "$CFLAGS" \$(MALLOC_FLAG) \$(FPIC_FLAG) \$(XOR_FLAG)">>environment.txt

	
	emake -j1
	emake -j1 links
}

src_install(){
	python_version
	
cat >> "${T}"/20ccpnmr << EOF
CCPNMR_TOP_DIR=/usr/lib/python${PYVER}/site-packages/
CCPNPYTHONPATH=/usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python
LD_LIBRARY_PATH=/usr/lib:/usr/lib:/usr/lib
TCL_LIBRARY=/usr/lib/tcl8.4
TK_LIBRARY=/usr/lib/tk8.4
EOF
	
	doenvd "${T}"/20ccpnmr || die "Failed to install env.d."
	
cat >> "${T}"/analysis << EOF
#!/bin/sh
${python} -O -i \${CCPNMR_TOP_DIR}/ccpnmr1.0/python/ccpnmr/analysis/AnalysisGui.py $1 $2 $3 $4 $5
EOF
	
cat >> "${T}"/dataShifter << EOF
#!/bin/sh
${python} -O \${CCPNPYTHONPATH}/ccpnmr/format/gui/DataShifter.py
EOF

cat >> "${T}"/formatConverter << EOF
#!/bin/sh
${python} -O \${CCPNPYTHONPATH}/ccpnmr/format/gui/FormatConverter.py $1 $2
EOF

cat >> "${T}"/pipe2azara << EOF
#!/bin/sh
${python} -O \${CCPNPYTHONPATH}/ccpnmr/analysis/NmrPipeData.py $1 $2 $3
EOF

cat >> "${T}"/updateAll << EOF
#!/bin/sh
${python} -O \${CCPNPYTHONPATH}/ccpnmr/update/UpdateAuto.py
EOF

cat >> "${T}"/updateCheck << EOF
#!/bin/sh
${python} -O \${CCPNPYTHONPATH}/ccpnmr/update/UpdatePopup.py
EOF

	exeinto /usr/bin
	doexe "${T}"/analysis || die "Failed to install wrapper."
	doexe "${T}"/dataShifter || die "Failed to install wrapper."
	doexe "${T}"/formatConverter || die "Failed to install wrapper."
	doexe "${T}"/pipe2azara || die "Failed to install wrapper."
	doexe "${T}"/updateAll || die "Failed to install wrapper."
	doexe "${T}"/updateCheck || die "Failed to install wrapper."
	
	insinto /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/
	cd ccpnmr/ccpnmr1.0
	doins -r *

	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccp/structure/*so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccp/structure/StructUtil.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccp/structure/StructAtom.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccp/structure/StructBond.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccp/structure/StructStructure.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/Midge.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/Dynamics.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/Bacus.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/AtomCoord.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/DistConstraintList.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/DistConstraint.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/CloudUtil.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/DistForce.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/clouds/AtomCoordList.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/ContourFile.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/ContourLevels.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/SliceFile.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/PeakList.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/ContourStyle.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/ccpnmr/analysis/WinPeakList.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/PdfHandler.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/TkHandler.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/FitMethod.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/BlockFile.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/MemCache.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/StoreFile.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/PsHandler.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/StoreHandler.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/c/memops/global/GlHandler.so
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/doc/graphics/prev.gif
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/doc/graphics/up.gif
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/doc/graphics/next.gif
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccp/c/linkSharedObjs
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/c/linkSharedObjs
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/CloudsPopup.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/HcloudsMdPopup.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/PseudoResonances.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/FilterCloudsPopup.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/HydrogenDynamics.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/FilterClouds.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/Clouds.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/MidgePopup.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/NoeRelaxation.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/FileIO.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/BacusPopup.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/ResonanceIdentification.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/__init__.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/ccpnmr/clouds/_licenseInfo.py
	fperms 755 /usr/lib/python${PYVER}/site-packages/ccpnmr1.0/python/memops/c/linkSharedObjs
}