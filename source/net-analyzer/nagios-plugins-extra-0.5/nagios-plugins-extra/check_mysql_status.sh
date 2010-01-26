#!/bin/bash

STATUS_OK="0";
STATUS_WARN="1";
STATUS_CRIT="2";
STATUS_UNKNOWN="3";

function die() {
	echo $2;
	exit $1;
}

function die_with_crit() {
	die $STATUS_CRIT $1;
}

if [ "$#" != 3 ]; then
	echo "USAGE: $0 <defaults-file> <conn-warn-limit> <conn-crit-limit>";
	echo "	(Values in percent!)";
	exit $STATUS_UNKNOWN;
fi

DEFAULTS_FILE="$1";
CONN_WARN="$2";
CONN_CRIT="$3";

if [ ! -r $DEFAULTS_FILE ]; then
	echo "Defaults file $DEFAULTS_FILE not readable!";
	exit $STATUS_UNKNOWN;
fi

MYSQLADMIN=$(which mysqladmin);
## sth. like /usr/bin/mysqladmin

if [ ! -x $MYSQLADMIN ]; then
	echo "Command $MYSQLADMIN not executable!";
	exit $STATUS_UNKOWN;
fi

STATUS_FILE=$(mktemp);
VARS_FILE=$(mktemp);

$MYSQLADMIN --defaults-extra-file=$DEFAULTS_FILE extended-status > $STATUS_FILE || die_with_crit "Could not read extended-status informations";
$MYSQLADMIN --defaults-extra-file=$DEFAULTS_FILE variables > $VARS_FILE || die_with_crit "Could not read variables";

qcache_size=$(cat $VARS_FILE | grep -i query_cache_size | gawk ' { print $4 }');
qcache_free=$(cat $STATUS_FILE | grep -i qcache_free_memory | gawk '{ print $4 }');
qcache_used=$(((${qcache_size}-${qcache_free})));

max_conns=$(cat $VARS_FILE | grep "max_connections" | gawk '{ print $4 }');
active_conns=$(cat $STATUS_FILE | grep "Threads_connected" | gawk '{ print $4 }');
free_conns=$(((${max_conns}-${active_conns})));

used_conns_percentage=$((((${active_conns}*100)/${max_conns})));


rm $STATUS_FILE;
rm $VARS_FILE;

RETURN_CODE=$STATUS_OK;
RETURN_TEXT="MySQL Ok";

if [ $used_conns_percentage -ge $CONN_CRIT ]; then
	RETURN_TEXT="MySQL critical (Uses ${active_conns} of ${max_conns} connections)";
	RETURN_CODE=$STATUS_CRIT;
elif [ $used_conns_percentage -ge $CONN_WARN ]; then
	RETURN_TEXT="MySQL warning (Uses ${active_conns} of ${max_conns} connections)";
	RETURN_CODE=$STATUS_WARN;
fi

PERF_DATA="query_cache_size=$qcache_size;query_cache_free=$qcache_free;query_cache_used=$qcache_used;max_connections=$max_conns;active_connections=$active_conns;free_conns=$free_conns;";

echo "$RETURN_TEXT | $PERF_DATA";
exit $RETURN_CODE;
