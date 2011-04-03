<?php
    function build_def(&$out, $ds, $arr, $file) {
        foreach ($arr as $key => $value) {
            $out .= "DEF:" . $key . "=$file:" . $ds[$value] . ":AVERAGE ";
        }
    }

    $opt[1] = "--title \"$servicedesc on $hostname\" ";
    $def[1] = "--vertical-label 'Bytes/s' ";
    build_def($def[1], $DS, array(
        "in_bytes" => 1,
        "in_pkt" => 2,
        "in_err" => 3,
        "out_bytes" => 4,
        "out_pkt" => 5,
        "out_err" => 6,
    ), $rrdfile);

    $def[1] .= "AREA:in_bytes#00FF00:\"Bytes In\"\\t ";
    $def[1] .= "LINE:in_pkt#000000:\"Packets In\"\\t ";
    $def[1] .= "LINE:in_err#FF3300:\"Errors In\"\\n ";
    $def[1] .= "AREA:out_bytes#009900:\"Bytes Out\"\\t ";
    $def[1] .= "LINE:out_pkt#0000CC:\"Packets Out\"\\t ";
    $def[1] .= "LINE:out_err#FF3300:\"Errors Out\"\\n ";
?>

