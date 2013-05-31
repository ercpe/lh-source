#!/bin/bash
# commentstrip - outputs file without comments or blanklines

if [ -z $1 ]; then
	echo "commentstrip <*x> <filename> - outputs file without comments or blanklines"
	exit
fi

case $1 in
   x | clipboard ) shift
   		if [[ `whoami` == root ]]; then
   			echo "Must be regular user to copy to clipboard.";
		else
			which xclip &> /dev/null && grep -vh '^[[:space:]]*\(#\|$\)' "$@" | xclip -selection c || echo "No xclip installed - emerge app-misc/stripcomments with the X flag";
		fi
		;;
	* )
		grep -vh '^[[:space:]]*\(#\|$\)' "$@"
		;;
esac
