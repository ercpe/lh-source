#!/bin/bash

tmp=$(mktemp -d);
commons="collections conf file io util runtime" 

P="mucommander-0.9.0";

out=${tmp}/${P}

function die() {
	echo "Something went wrong!";
	exit 1;
}

echo "Creating source tarball in ${tmp}";

# grab latest code from svn repository
svn export https://svn.mucommander.com/mucommander/tags/release_0_9_0/ ${out}  > /dev/null || die

for x in ${commons}; do
svn export https://svn.mucommander.com/mucommander-commons-${x}/trunk/ ${tmp}/commons-${x}  > /dev/null || die
	rm -rf ${tmp}/commons-${x}/{build.xml,*.properties} \
		${tmp}/commons-${x}/res/ivy/ \
		${tmp}/commons-${x}/res/runtime/META-INF 
	cp -r ${tmp}/commons-${x}/* ${out} || die
done

# the runtime commons differs from the svn tree :/
wget http://ivy.mucommander.com/mucommander/mucommander-commons-runtime/1.0.0-b20/com.mucommander.commons.runtime-sources.jar -O ${tmp}/com.mucommander.commons.runtime.jar  > /dev/null || die
unzip -d ${tmp}/commons-runtime-jar -o ${tmp}/com.mucommander.commons.runtime.jar > /dev/null || die
cp -r ${tmp}/commons-runtime-jar/com ${out}/src/main/ > /dev/null


mkdir -p ${out}/lib/{tools,test,compile,runtime} || die

pushd ${tmp}
tfile="${P}.tar.bz2";
tar cjpf ${P}.tar.bz2 ${P} || die
popd

rm -rf ${tmp}/commons-* ${tmp}/*.jar

echo "Created source tarball: /tmp/${tfile}" 