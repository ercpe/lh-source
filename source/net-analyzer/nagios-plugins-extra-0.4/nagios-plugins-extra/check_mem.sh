#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3


if [ $# -lt 2 ]; then
    echo "USAGE: $0 -w <warning> -c <critical>"
    exit $STATE_UNKOWN;
fi

warning=40
critical=20

while [[ $# -gt 0 ]]; do
    case "$1" in
        -w|--warning)
            shift
            warning=$1
        ;;
        -c|--critical)
            shift
            critical=$1
        ;;
    esac
    shift
done

PERFDATA="";

total=$(free -m | head -2 |tail -1 |gawk '{print $2}');
used=$(free -m | head -2 |tail -1 |gawk '{print $3}');
buffers=$(free -m | head -2 |tail -1 |gawk '{print $6}');
cached=$(free -m | head -2 |tail -1 |gawk '{print $7}');
free=$(free -m | head -2 |tail -1 |gawk '{print $4}');
shared=$(free -m | head -2 |tail -1 |gawk '{print $5}');


#             total       used       free     shared    buffers     cached
#Mem:          1980       1577        403          0        198        733

real_used=$((($used-($buffers+$cached+$shared))));
real_free=$((($total-($used-$buffers-$cached-$shared))));

PERFDATA="total=$total;used=$real_used;free=$free;shared=$shared;buffers=$buffers;cached=$cached";

free_percentage=$(((($real_free*100)/$total)))

if [ "$free_percentage" -lt "$critical" ]; then
    echo "Memory CRITCAL - $real_free MB free, $real_used MB used | $PERFDATA";
    exit $STATUS_CRITCAL;
elif [ "$free_percentage" -lt "$warning" ]; then
    echo "Memory WARNING - $real_free MB free, $real_used MB used | $PERFDATA";
    exit $STATUS_WARNING;
else
    echo "Memory OK - $real_free MB free, $real_used MB used | $PERFDATA";
    exit $STATUS_OK;
fi
