#!/bin/bash

if [ -r /proc/net/ip_conntrack ]; then
	cat /proc/net/ip_conntrack | awk '
	  BEGIN  { STATE["ESTABLISHED"]=STATE["FIN_WAIT"]=STATE["TIME_WAIT"]=0;
	           ASSURED=NOREPLY=NATED=STATE["SYN_SENT"]=STATE["UDP"]=0; }
	  /^tcp/ { STATE[$4]++; }
	  /^udp/ { STATE["UDP"]++; }
	  /ASSURED/ { ASSURED++; }
	  {
	      TOTAL++;
	      src1 = substr($5, 5); src2 = substr($9, 5);
	      dst1 = substr($6, 5); dst2 = substr($10, 5);
	      if (src1 != dst2 || dst1 != src2) NATED++;
	  }
	  END    { print "Connections OK | established=" STATE["ESTABLISHED"] ";fin_wait=" STATE["FIN_WAIT"] ";time_wait=" STATE["TIME_WAIT"] ";syn_sent=" STATE["SYN_SENT"] ";udp=" STATE["UDP"] ";assured=" ASSURED ";nated=" NATED ";total=" TOTAL;
	         }'
else
	echo "IP conntrack support missing in kernel or /proc/net/ip_conntrack is not readable";
	exit 3;
fi