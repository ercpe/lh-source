#!/bin/sh
 
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
PROGNAME=`basename $0`
VERSION="Version 1.0,"
AUTHOR="2009, Mike Adolphs (http://www.matejunkie.com/)"
 
ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3
path_pid="/var/run/named"
name_pid="named.pid"
path_stats="/var/bind"
version=9.4
 
print_version() {
    echo "$VERSION $AUTHOR"
}
 
print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check the bind daemon whether it's"
    echo "running via its pid file and then gets the statistics via rndc stats."
    echo "The user that run the script needs the ability to 'sudo rndc stats'!"
    echo "The timeframe in which the rndc stats output is updated is controlled"
    echo "by the check interval. The output shows amount of requests of various"
    echo "types occured during the last check interval."
    echo "The script itself is written sh-compliant and free software under the"
    echo "terms of the GPLv2 (or later)."
    echo ""
    echo "$PROGNAME -p/--path_pid /var/run/named -n/--name_pid named.pid"
    echo "  -s/--path-stats /var/bind -V/--bind-version 9.4/9.5"
    echo "Options:"
    echo "  -p/--path-pid)"
    echo "     Path where the pid file for bind is stored. You might need to"
    echo "     alter this to your distribution's way of dealing with pid files."
    echo "     Default is: /var/run/named"
    echo "  -n/--name-pid)"
    echo "     Name of the pid file. Default is: named.pid"
    echo "  -s/--path-stats)"
    echo "     Path where the named.stats file is stored. Default is:"
    echo "     /var/bind"
    echo "  -V/--bind-version)"
    echo "     Specifies the bind version you're running. Currently only 9.4"
    echo "     is supported. In Bind 9.5 the stats output changed massively."
    echo "     It'll take a couple of more days to implement this. Default"
    echo "     is: 9.4"
    exit $ST_UK
}
 
while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --path-pid|-p)
            path_pid=$2
            shift
            ;;
        --name-pid|-n)
            name_pid=$2
            shift
            ;;
        --bind-version|-V)
            version=$2
            shift
            ;;
        --path-stats|-s)
            path_stats=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
    esac
    shift
done
 
case "$version" in
    9.4)
        check_pid() {
            if [ -f "$path_pid/$name_pid" ]
            then
                retval=0
            else
                retval=1
            fi
        }
 
        trigger_stats() {
            sudo rndc stats
        }
 
        get_vals() {
            succ_1st=`tail -n22 $path_stats/named.stats | grep -o '^success [0-9]*' | sort -r | grep -m1 '^success [0-9]*' | awk '{print $2}'`
            succ_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^success [0-9]*' | sort -r | awk '{print $2}'`
            success=`expr $succ_1st - $succ_2nd`
 
            ref_1st=`tail -n22 $path_stats/named.stats | grep -o '^referral [0-9]*' | sort -r | grep -m1 '^referral [0-9]*' | awk '{print $2}'`
            ref_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^referral [0-9]*' | sort -r | awk '{print $2}'`
            referral=`expr $ref_1st - $ref_2nd`
 
            nxrr_1st=`tail -n22 $path_stats/named.stats | grep -o '^nxrrset [0-9]*' | sort -r | grep -m1 '^nxrrset [0-9]*' | awk '{print $2}'`
            nxrr_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^nxrrset [0-9]*' | sort -r | awk '{print $2}'`
            nxrrset=`expr $nxrr_1st - $nxrr_2nd`
 
            nxdom_1st=`tail -n22 $path_stats/named.stats | grep -o '^nxdomain [0-9]*' | sort -r | grep -m1 '^nxdomain [0-9]*' | awk '{print $2}'`
            nxdom_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^nxdomain [0-9]*' | sort -r | awk '{print $2}'`
            nxdomain=`expr $nxdom_1st - $nxdom_2nd`
 
            rec_1st=`tail -n22 $path_stats/named.stats | grep -o '^recursion [0-9]*' | sort -r | grep -m1 '^recursion [0-9]*' | awk '{print $2}'`
            rec_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^recursion [0-9]*' | sort -r | awk '{print $2}'`
            recursion=`expr $rec_1st - $rec_2nd`
 
            fail_1st=`tail -n22 $path_stats/named.stats | grep -o '^failure [0-9]*' | sort -r | grep -m1 '^failure [0-9]*' | awk '{print $2}'`
            fail_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^failure [0-9]*' | sort -r | awk '{print $2}'`
            failure=`expr $fail_1st - $fail_2nd`
 
            dup_1st=`tail -n22 $path_stats/named.stats | grep -o '^duplicate [0-9]*' | sort -r | grep -m1 '^duplicate [0-9]*' | awk '{print $2}'`
            dup_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^duplicate [0-9]*' | sort -r | awk '{print $2}'`
            duplicate=`expr $dup_1st - $dup_2nd`
 
            drop_1st=`tail -n22 $path_stats/named.stats | grep -o '^dropped [0-9]*' | sort -r | grep -m1 '^dropped [0-9]*' | awk '{print $2}'`
            drop_2nd=`tail -n22 $path_stats/named.stats | grep -m1 '^dropped [0-9]*' | sort -r | awk '{print $2}'`
            dropped=`expr $drop_1st - $drop_2nd`
        }
 
        get_perfdata() {
            perfdata=`echo "'success'=$success 'referral'=$referral 'nxrrset'=$nxrrset 'nxdomain'=$nxdomain 'recursion'=$recursion 'failure'=$failure 'duplicate'=$duplicate 'dropped'=$dropped"`
        }
        ;;
    9.5)
        echo "Please use -V 9.4 at the moment. Support for 9.5 is not yet implemented."
        exit $ST_UK
        ;;
	9.7)
        check_pid() {
            if [ -f "$path_pid/$name_pid" ]
            then
                retval=0
            else
                retval=1
            fi
        }

        trigger_stats() {
            sudo rndc stats
        }

        get_vals() {
			stats_last=$(tail -n240 $path_stats/named.stats | sed '/++ Name Server Statistics ++/,/++/!d' | grep -Po '(\s+\d+\s.*)' | awk -v 'RS=\n\n' '1;{exit}');
			stats_cur=$(tail -n120 $path_stats/named.stats | sed '/++ Name Server Statistics ++/,/++/!d' | grep -Po '(\s+\d+\s.*)');

			success_cur=$(echo $stats_cur | grep -Po '(\d+) queries resulted in successful answer' | awk '{ print $1; }');
			nxrrset_cur=$(echo $stats_cur | grep -Po "(\d+) queries resulted in nxrrset" | awk '{ print $1; }');
			nxdomain_cur=$(echo $stats_cur | grep -Po "(\d+) queries resulted in NXDOMAIN" | awk '{ print $1; }');
			recursion_cur=$(echo $stats_cur | grep -Po "(\d+) queries caused recursion" | awk '{ print $1; }');
			failure_cur=$(echo $stats_cur | grep -Po "(\d+) queries resulted in SERVFAIL" | awk '{ print $1; }');
			duplicate_cur=$(echo $stats_cur | grep -Po "(\d+) duplicate queries received" | awk '{ print $1; }');
			dropped_cur=$(echo $stats_cur | grep -Po "(\d+) other query failures" | awk '{ print $1; }');

			success_last=$(echo $stats_last | grep -Po '(\d+) queries resulted in successful answer' | awk '{ print $1; }');
			nxrrset_last=$(echo $stats_last | grep -Po "(\d+) queries resulted in nxrrset" | awk '{ print $1; }');
			nxdomain_last=$(echo $stats_last | grep -Po "(\d+) queries resulted in NXDOMAIN" | awk '{ print $1; }');
			recursion_last=$(echo $stats_last | grep -Po "(\d+) queries caused recursion" | awk '{ print $1; }');
			failure_last=$(echo $stats_last | grep -Po "(\d+) queries resulted in SERVFAIL" | awk '{ print $1; }');
			duplicate_last=$(echo $stats_last | grep -Po "(\d+) duplicate queries received" | awk '{ print $1; }');
			dropped_last=$(echo $stats_last | grep -Po "(\d+) other query failures" | awk '{ print $1; }');

			success=`expr $success_cur - $success_last`
			nxrrset=`expr $nxrrset_cur - $nxrrset_last`
			nxdomain=`expr $nxdomain_cur - $nxdomain_last`
			recursion=`expr $recursion_cur - $recursion_last`
			failure=`expr $failure_cur - $failure_last`
			duplicate=`expr $duplicate_cur - $duplicate_last`
			dropped=`expr $dropped_cur - $dropped_last`

			if [ "$success" == "-" ]; then
				success="0"
			fi
			if [ "$nxrrset" == "-" ]; then
				nxrrset="0"
			fi
			if [ "$nxdomain" == "-" ]; then
				nxdomain="0"
			fi
			if [ "$recursion" == "-" ]; then
				recursion="0"
			fi
			if [ "$failure" == "-" ]; then
				failure="0"
			fi
			if [ "$duplicate" == "-" ]; then
				duplicate="0"
			fi
			if [ "$dropped" == "-" ]; then
				dropped="0"
			fi

			referral=0
        }

        get_perfdata() {
            perfdata=`echo "'success'=$success 'referral'=$referral 'nxrrset'=$nxrrset 'nxdomain'=$nxdomain 'recursion'=$recursion 'failure'=$failure 'duplicate'=$duplicate 'dropped'=$dropped"`
        }

		;;
    *)
        echo "Please use -V 9.4 at the moment. Support for 9.5 is not yet implemented."
        exit $ST_UK
        ;;
esac
 
check_pid
if [ "$retval" = 1 ]
then
    echo "There's no pid file for bind9. Is it actually running?"
    exit $ST_CR
else
    trigger_stats
    get_vals
    get_perfdata
 
    echo "Bind9 is running. $success successfull requests, $referral referrals, $nxdomain nxdomains since last check. | $perfdata"
    exit $ST_OK
fi
