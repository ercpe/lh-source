<?php
    function build_def(&$out, $ds, $arr, $file) {
        foreach ($arr as $key => $value) {
            $out .= "DEF:" . $key . "=$file:" . $ds[$value] . ":AVERAGE ";
        }
    }

    $opt[1] = "--title \"Apache Worker status on $hostname\" ";
    $def[1] = "";
	build_def($def[1], $DS, array(
		"wait_conn" => 1,
		"start_up" => 2,
		"read_req" => 3,
		"send_repl" => 4,
		"keep_alive" => 5,
		"dns_lookup" => 6,
		"close_conn" => 7,
		"logging" => 8,
		"grace_finish" => 9,
		"idle_clean" => 10,
		"open_slot" => 11,
	), $rrdfile);

	$def[1] .= "AREA:wait_conn#00FF00:\"Waiting for connection\"\\t ";
	$def[1] .= "STACK:start_up#99FF00:\"Starting up\"\\t ";
	$def[1] .= "STACK:read_req#FFFF00:\"Reading request\"\\n ";
	$def[1] .= "STACK:send_repl#FF9900:\"Sending reply\"\\t\\t ";
	$def[1] .= "STACK:keep_alive#336600:\"Keepalive\"\\t ";
	$def[1] .= "STACK:dns_lookup#cc3300:\"DNS Lookup\"\\n ";
	$def[1] .= "STACK:close_conn#6633CC:\"Closing connection\"\\t ";
	$def[1] .= "STACK:logging#999999:\"Logging\"\\t ";
	$def[1] .= "STACK:grace_finish#FF66FF:\"Gracefully finishing\"\\n ";
	$def[1] .= "STACK:idle_clean#FF99cc:\"Idle cleanup\"\\n ";
//	$def[1] .= "STACK:open_slot#009966:\"Open slot\"\\n ";

    $opt[2] = "--title \"Apache status on $hostname\" ";
    $def[2] = "";
	build_def($def[2], $DS, array(
		"req_second" => 12,
		"kb_second" => 13,
		"kb_request" => 14,
	), $rrdfile);
	$def[2] .= "LINE:req_second#000000:\"Requests per second\"\\t ";
	$def[2] .= "LINE:kb_second#3300FF:\"kB per second\"\\t ";
	$def[2] .= "LINE:kb_request#00CC00:\"kB per request\" ";
?>
