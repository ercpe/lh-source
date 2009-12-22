#!/bin/bash

STATUS_OK="0";
STATUS_WARN="1";
STATUS_CRIT="2";
STATUS_UNKNOWN="3";

JAIL="$1";

if [ -z $JAIL ]; then
        echo "USAGE: $0 <jail>";
        exit $STATUS_UNKNOWN;
fi

CLIENT=$(which fail2ban-client);

if [ -x $CLIENT ]; then
        NUM_BANNED=$(sudo ${CLIENT} status $JAIL | awk '/Currently banned:/ { print $NF }');
        echo "${NUM_BANNED} clients banned against $JAIL | banned=${NUM_BANNED}";
        exit $STATUS_OK;
else
        echo "Fail2ban-client not executable";
        exit $STATUS_UNKNOWN;
fi
