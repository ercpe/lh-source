
<?php

$opt[1] = "--vertical-label \"Connections \" -l 0 -r --title \"Connection tracking for $hostname / $servicedesc\" ";

//established fin_wait time_wait syn_sent udp assured nated total

$a = array(
	array("established", "#008000"),
	array("fin_wait", "#0C1418"),
	array("time_wait", "#E80C3E"),
	array("syn_sent", "#FFA500"),
	array("udp", "#1CC8E8"),
	array("assured", "#E80C8C"),
	array("nated", "#00FF3F"),
	array("total", "#0C64E8")
);

$def[1] = "";
$def[1] .= "DEF:established=$rrdfile:$DS[1]:AVERAGE " ;
$def[1] .= "DEF:fin_wait=$rrdfile:$DS[2]:AVERAGE " ;
$def[1] .= "DEF:time_wait=$rrdfile:$DS[3]:AVERAGE " ;
$def[1] .= "DEF:syn_sent=$rrdfile:$DS[4]:AVERAGE " ;
$def[1] .= "DEF:udp=$rrdfile:$DS[5]:AVERAGE " ;
$def[1] .= "DEF:assured=$rrdfile:$DS[6]:AVERAGE " ;
$def[1] .= "DEF:nated=$rrdfile:$DS[7]:AVERAGE " ;
$def[1] .= "DEF:total=$rrdfile:$DS[8]:AVERAGE " ;

$def[1] .= "COMMENT:\"\\t\\t\\t\\tLAST\\t\\tAVERAGE\\tMAX\\n\" " ;

foreach ($a as $x) {
	$def[1] .= "LINE2:" . $x[0] . $x[1] . ":\"" . $x[0] . str_repeat('\\t', strlen($x[0]) > 7 ? 2 : (strlen($x[0]) > 5 ? 2 : 3)) . "\" " ;
	$def[1] .= "GPRINT:" . $x[0] . ":LAST:\"%6.0lf\\t\" " ;
	$def[1] .= "GPRINT:" . $x[0] . ":AVERAGE:\" %6.0lf\\t\" " ;
	$def[1] .= "GPRINT:" . $x[0] . ":MAX:\" %6.0lf\\n\" " ;
}

?>
