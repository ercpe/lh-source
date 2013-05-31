#!/bin/bash
if [ "$#" != 1 ]; then exit 0; fi;

CONFFILE="/etc/walloffire/walloffire.conf"

[[ -r "${CONFFILE}" ]] && source "${CONFFILE}"

for file in ${1}/*; do
	einfo "	Processing rule set $(basename ${file})"
	cat ${file} | sed -e '/^#/d' -e '/^$/d' | \
	while read line; do
		[[ ${FW_DEBUG} == "true" ]] && eval "echo ${line}"
		eval "${line}" &> /dev/null;
		if [ $? != 0 ]; then
			ewarn "Error processing rule: ${line} in file ${file}";
		fi
	done
done
