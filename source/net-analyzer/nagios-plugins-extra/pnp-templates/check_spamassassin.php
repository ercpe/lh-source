<?php
    $opt[1] = "--title \"Spam and Ham on $hostname\" ";
    $def[1] = "";
	$def[1] .= "COMMENT:\"\\t\\t\\tLast\\t\\tMax\\t\\tAvg \\n\" ";


	$def[1] .= "DEF:total_spam=" . $rrdfile . ":" . $DS[1] . ':AVERAGE ';
	$def[1] .= "DEF:total_ham=" . $rrdfile . ":" . $DS[2] . ':AVERAGE ';

	$def[1] .= "AREA:total_spam#CC0000:\"Total SPAM\"\\t\\t ";
    $def[1] .= "GPRINT:total_spam:LAST:\"%3.1lf %s$UNIT[1] \" ";
    $def[1] .= "GPRINT:total_spam:MAX:\"%3.1lf %s$UNIT[1] \" ";
    $def[1] .= "GPRINT:total_spam:AVERAGE:\"%3.1lf %s$UNIT[1] \\n\" ";


	$def[1] .= "STACK:total_ham#00CC00:\"Total HAM\"\\t\\t ";
    $def[1] .= "GPRINT:total_ham:LAST:\"%3.1lf %s$UNIT[1] \" ";
    $def[1] .= "GPRINT:total_ham:MAX:\"%3.1lf %s$UNIT[1] \" ";
    $def[1] .= "GPRINT:total_ham:AVERAGE:\"%3.1lf %s$UNIT[1] \\n\" ";



    $opt[2] = "--title \"Spamassassin scoring on $hostname\" ";
    $def[2] = "";
	$def[2] .= "COMMENT:\"\\t\\t\\t\\tLast\\t\\tMax\\t\\tAvg \\n\" ";

	$def[2] .= "DEF:min=" . $rrdfile . ":" . $DS[3] . ':AVERAGE ';
	$def[2] .= "DEF:max=" . $rrdfile . ":" . $DS[4] . ':AVERAGE ';
	$def[2] .= "DEF:avg=" . $rrdfile . ":" . $DS[5] . ':AVERAGE ';


	$def[2] .= "LINE:min#0000FF:\"Minimum score\"\\t ";
    $def[2] .= "GPRINT:min:LAST:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:min:MAX:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:min:AVERAGE:\"%3.3lf %s$UNIT[1] \\n\" ";

	$def[2] .= "LINE:max#00CC00:\"Maximum score\"\\t ";
    $def[2] .= "GPRINT:max:LAST:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:max:MAX:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:max:AVERAGE:\"%3.3lf %s$UNIT[1] \\n\" ";

	$def[2] .= "LINE:avg#CC0000:\"Average score\"\\t ";
    $def[2] .= "GPRINT:avg:LAST:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:avg:MAX:\"%3.3lf %s$UNIT[1] \" ";
    $def[2] .= "GPRINT:avg:AVERAGE:\"%3.3lf %s$UNIT[1] \\n\" ";

?>
