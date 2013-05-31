<?php
    $opt[1] = "--title \"Amavis timings on $hostname\" ";
    $def[1] = "";
	$def[1] .= "COMMENT:\"\\t\\t\\t\\t\\t   Last\\t\\t  Max\\t\\t\\t  Avg \\n\" ";

	$my_defs = array(
				array('parse', 10, '#000000', 'Parsing message', 2),
				array('extract_message_metadata', 6, '#FF3300', 'Extract Metadata', 2),
				array('poll_dns_idle', 11, '#FF6600', NULL, 2),
				array('get_uri_detail_list', 8, '#339900', NULL, 1),
				array('tests_pri_1000', 12, '#330000', NULL, 2),
				array('tests_pri_950', 15, '#660000', NULL, 2),
				array('tests_pri_900', 14, '#990000', NULL, 2),
				array('tests_pri_400', 13, '#BB0000', NULL, 2),
				array('check_bayes', 1, '#003300', 'Bayes check', 3),
				array('tests_pri_0', 16, '#FF0000', NULL, 2),
				array('check_dkim_signature', 3, '#0000FF', 'DKIM Signature check', 1),
				array('check_dkim_adsp', 2, '#000099', 'DKIM ADSP check', 2),
				array('check_razor2', 5, '#CC66FF', 'Razor2', 2),
				array('check_pyzor', 4, '#CC00FF', 'Pyzor', 4),
				array('tests_pri_500', 17, '#00FFFF', NULL, 2),
				array('get_report', 7, '#CCFFFF', NULL, 3),
				);

    foreach ($my_defs as $x) {
    	$dr_name = $x[0];
    	$dr_idx = $x[1];
    	$def[1] .= "DEF:" . $dr_name . "=" . $rrdfile . ":" . $DS[$dr_idx] . ':AVERAGE ';
	}

	foreach ($my_defs as $x) {
    	$dr_name = $x[0];
    	$dr_idx = $x[1];
    	$dr_color = $x[2];
    	$dr_text = $x[3];
		$dr_indent = $x[4];

		if (!$dr_text) {
			$dr_text = $dr_name;
		}

		$indent = "";
		for($i=0; $i < $dr_indent; $i++) {
			$indent .= "\\t";
		}

		$def[1] .= "LINE:" . $dr_name . $dr_color . ":\"" . $dr_text . "\"\\t" . $indent . " ";
		$def[1] .= "GPRINT:" . $dr_name . ":LAST:\"%.2lf \"\\t\\t ";
		$def[1] .= "GPRINT:" . $dr_name . ":MAX:\"%4.2lf \"\\t ";
		$def[1] .= "GPRINT:" . $dr_name . ":AVERAGE:\"%.2lf \\n\" ";
	}

?>


