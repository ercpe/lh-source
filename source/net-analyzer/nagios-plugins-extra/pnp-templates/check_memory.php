<?php
	#
	$opt[1] = "--title \"Memory usage on $hostname\" ";

	#
	$def[1] = "";


	$def[1] .=  "DEF:avail=$rrdfile:$DS[1]:AVERAGE " ;
	$def[1] .=  "DEF:used=$rrdfile:$DS[2]:AVERAGE " ;
	$def[1] .=  "DEF:free=$rrdfile:$DS[3]:AVERAGE " ;
	$def[1] .=  "DEF:shared=$rrdfile:$DS[4]:AVERAGE " ;
	$def[1] .=  "DEF:buffers=$rrdfile:$DS[5]:AVERAGE " ;
	$def[1] .=  "DEF:cached=$rrdfile:$DS[6]:AVERAGE " ;


	$def[1] .= "AREA:used#CC0000:\"Used Memory\" ";
	$def[1] .= "STACK:shared#FFFF00:\"Shared Memory\" ";
	$def[1] .= "STACK:buffers#0000FF:\"Buffered Memory\" ";
	$def[1] .= "STACK:cached#FFCC00:\"Cached Memory\" ";
	$def[1] .= "STACK:free#00CC00:\"Free Memory\" ";

	$def[1] .= "LINE:avail#000000:\"Available Memory \" " ;

?>
