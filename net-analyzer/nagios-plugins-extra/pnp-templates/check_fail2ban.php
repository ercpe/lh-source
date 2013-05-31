<?php
    function build_def(&$out, $ds, $arr, $file) {
        global $rrdfile;
        foreach ($arr as $key => $value) {
            $out .= "DEF:" . $key . "=$file:" . $ds[$value] . ":AVERAGE ";
        }
    }

    $opt[1] = "--title \"Banned clients against SSH on $hostname\" ";
    $def[1] = "--vertical-label 'Banned IPs' ";
    build_def($def[1], $DS, array(
        "banned" => 1,
    ), $rrdfile);

    $def[1] .= "AREA:banned#eacc00:\"Banned\"\\t ";
	$def[1] .= "GPRINT:banned:LAST:\"Last\:%3.0lf\\t\" " ;
	$def[1] .= "GPRINT:banned:AVERAGE:\"Avg\: %3.0lf\\t\" " ;
	$def[1] .= "GPRINT:banned:MAX:\"Max\: %3.0lf\\n\" " ;
    $def[1] .= "LINE:banned#000000 ";


/*
    $def[1] .= "LINE:in_err#FF3300:\"Errors\"\\n ";
    $def[1] .= "AREA:out_bytes#00FF00:\"Bytes\"\\t ";
    $def[1] .= "LINE:out_pkt#000000:\"Packets\"\\t ";
    $def[1] .= "LINE:out_err#FF3300:\"Errors\"\\n ";
*/
?>

