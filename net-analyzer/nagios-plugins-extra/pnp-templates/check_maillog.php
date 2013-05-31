<?php
    #
    $opt[1] = "--title \"Mail log analysis on $hostname\" ";

    #
    $def[1] = "";
    $def[1] .= "COMMENT:\"\\t\\t\\t\\t  Last\\tMax\\t  Avg \\n\" ";


    $def[1] .=  "DEF:m_ok=$rrdfile:$DS[1]:AVERAGE " ;
    $def[1] .= "AREA:m_ok#00CC00:\"Mails OK\\t\\t\\t\" ";
	$def[1] .= "GPRINT:m_ok:LAST:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_ok:MAX:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_ok:AVERAGE:\"%3.0lf %s$UNIT[1] \\n\" ";


    $def[1] .=  "DEF:m_spam=$rrdfile:$DS[2]:AVERAGE " ;
    $def[1] .= "STACK:m_spam#0033ff:\"SPAM mails\\t\\t\\t\" ";
	$def[1] .= "GPRINT:m_spam:LAST:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_spam:MAX:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_spam:AVERAGE:\"%3.0lf %s$UNIT[1] \\n\" ";

    $def[1] .=  "DEF:m_inf=$rrdfile:$DS[3]:AVERAGE " ;
    $def[1] .= "STACK:m_inf#FF0000:\"Infected mails\\t\\t\" ";
	$def[1] .= "GPRINT:m_inf:LAST:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_inf:MAX:\"%3.0lf %s$UNIT[1] \" ";
	$def[1] .= "GPRINT:m_inf:AVERAGE:\"%3.0lf %s$UNIT[1] \\n\" ";


    //$def[1] .=  "DEF:m_uninf=$rrdfile:$DS[4]:AVERAGE " ;

	$opt[2] = "--title \"Rejected Mails / Connections on $hostname\"";
    $def[2] = "";
    $def[2] .= "COMMENT:\"\\t\\t\\t\\t  Last\\tMax\\t  Avg \\n\" ";


    $def[2] .=  "DEF:m_rej=$rrdfile:$DS[5]:AVERAGE " ;
    $def[2] .= "AREA:m_rej#003366:\"Rejected mails\\t\\t\" ";
	$def[2] .= "GPRINT:m_rej:LAST:\"%3.0lf %s$UNIT[1] \" ";
	$def[2] .= "GPRINT:m_rej:MAX:\"%3.0lf %s$UNIT[1] \" ";
	$def[2] .= "GPRINT:m_rej:AVERAGE:\"%3.0lf %s$UNIT[1] \\n\" ";


    $def[2] .=  "DEF:m_conn=$rrdfile:$DS[6]:AVERAGE " ;
    $def[2] .= "LINE:m_conn#000000:\"Connection attempts\\t\" " ;
	$def[2] .= "GPRINT:m_conn:LAST:\"%3.0lf %s$UNIT[1] \" ";
	$def[2] .= "GPRINT:m_conn:MAX:\"%3.0lf %s$UNIT[1] \" ";
	$def[2] .= "GPRINT:m_conn:AVERAGE:\"%3.0lf %s$UNIT[1] \\n\" ";
?>
