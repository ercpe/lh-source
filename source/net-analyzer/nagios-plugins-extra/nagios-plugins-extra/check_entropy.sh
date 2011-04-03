#!/bin/sh

entropy_file="/proc/sys/kernel/random/entropy_avail"

if [ -f "$entropy_file" ]; then
	min="$1";

	ea=$(cat $entropy_file);
	msg="Entropy available: ${ea}";

	echo $msg

	if [ -n "$min" ]; then
		if [ "$ea" -lt "$min" ]; then
			exit 1
		fi
	fi
	exit 0
else
	echo "Entropy file not available";
	exit 3
fi;
