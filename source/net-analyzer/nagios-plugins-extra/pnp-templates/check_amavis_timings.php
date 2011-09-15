<?php
    $opt[1] = "--title \"Amavis timings on $hostname\" ";
    $def[1] = "";
	$def[1] .= "COMMENT:\"\\t\\t\\tLast\\t\\tMax\\t\\tAvg \\n\" ";

	
	$my_defs = array(
				array('parse', 11, '#FFFFFF', 'Parsing message'),
				array('extract_message_metadata', 7, '#FFFFFF', NULL),
				array('poll_dns_idle', 12, '#FFFFFF', NULL),
				array('get_uri_detail_list', 9, '#FFFFFF', NULL),
				array('tests_pri_1000', 13, '#FFFFFF', NULL),
				array('tests_pri_950', 16, '#FFFFFF', NULL),
				array('tests_pri_900', 15, '#FFFFFF', NULL),
				array('tests_pri_400', 14, '#FFFFFF', NULL),
				array('check_bayes', 1, '#FFFFFF', 'Bayes check'),
				array('tests_pri_0', 17, '#FFFFFF', NULL),
				array('check_dkim_signature', 3, '#FFFFFF', 'DKIM Signature check'),
				array('check_dkim_adsp', 2, '#FFFFFF', 'DKIM ADSP check'),
				array('check_razor2', 5, '#FFFFFF', 'Razor2'),
				array('check_pyzor', 4, '#FFFFFF', 'Pyzor'),
				array('tests_pri_500', 18, '#FFFFFF', NULL),
				array('get_report', 8, '#FFFFFF', NULL),
				);

    foreach ($my_defs as $x) {
    	$dr_name = $x[0];
    	$dr_idx = $x[1];
    	$def[1] .= "DEF:" . $dr_name . "=" . $rrdfile . ":" . $DS[$dr_index] . ':AVERAGE ';
	}

	foreach ($my_defs as $x) {
    	$dr_name = $x[0];
    	$dr_idx = $x[1];
    	$dr_color = $x[2];
    	$dr_text = $x[3];

		if (!$dr_text) {
			$dr_text = $dr_name;
		}

		$def[1] .= "LINE:" . $dr_name . $dr_color":\"" . $dr_text . "\"\\t\\t ";
		$def[1] .= "GPRINT:" . $dr_name . ":LAST:\"%3.1lf %s$UNIT[1] \" ";
		$def[1] .= "GPRINT:" . $dr_name . ":MAX:\"%3.1lf %s$UNIT[1] \" ";
		$def[1] .= "GPRINT:" . $dr_name . ":AVERAGE:\"%3.1lf %s$UNIT[1] \\n\" ";
	}

?>
