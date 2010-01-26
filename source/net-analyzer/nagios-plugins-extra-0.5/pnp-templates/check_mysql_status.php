<?php
	#
	$opt[1] = "--title \"MySQL Query Cache on $hostname\" ";

	#
	$def[1] = "";

	$def[1] .=  "DEF:qc_size=$rrdfile:$DS[1]:AVERAGE " ;
	$def[1] .=  "DEF:qc_free=$rrdfile:$DS[2]:AVERAGE " ;
	$def[1] .=  "DEF:qc_used=$rrdfile:$DS[3]:AVERAGE " ;

	$def[1] .= "AREA:qc_used#CC0000:\"Query cache used\" ";
	$def[1] .= "STACK:qc_free#00CC00:\"Query cache free\" ";
	$def[1] .= "LINE:qc_size#000000:\"Query cache max \" " ;



	#
	$opt[2] = "--title \"MySQL Connections on $hostname\" ";

	#
	$def[2] = "";

	$def[2] .=  "DEF:conn_max=$rrdfile:$DS[4]:AVERAGE " ;
	$def[2] .=  "DEF:conn_act=$rrdfile:$DS[5]:AVERAGE " ;
	$def[2] .=  "DEF:conn_free=$rrdfile:$DS[6]:AVERAGE " ;

	$def[2] .= "AREA:conn_act#CC0000:\"Active connections\" ";
	$def[2] .= "STACK:conn_free#00CC00:\"Free connections\" ";
	$def[2] .= "LINE:conn_max#000000:\"Max connections \" " ;

?>
