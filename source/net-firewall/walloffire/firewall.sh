#!/bin/bash
if [ "$#" != 1 ]; then exit 0; fi;

if [ -f "/etc/walloffire/walloffire.conf" ]; then
	source "/etc/walloffire/walloffire.conf"
fi

for file in ${1}/*; do
	cat $file | while read line; do
		eval "$line" &> /dev/null;
		if [ $? != 0 ]; then
			echo "Error processing rule: $line in file $file";
		fi
	done
done
