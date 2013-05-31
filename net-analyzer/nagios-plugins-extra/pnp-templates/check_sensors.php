<?php
	$i = 1;

	$my_colors = array('#0000CC', '#339900', '#CC3300', '#872187', '#FF4848', '#DFDF00', '#B96F6F', '#990099');

    function startsWith($haystack, $needle) {
        $length = strlen($needle);
        return (substr($haystack, 0, $length) === $needle);
    }

	foreach (array('temp', 'coretemp', 'fan', 'in') as $prefix) {
		$graph_label = "";
		$vertical_label = "";

		if ($prefix == "temp") {
			$graph_label = "Temperatures on $hostname";
			$vertical_label = '°C';
		}
		if ($prefix == "coretemp") {
			$graph_label = "Core temperatures on $hostname";
			$vertical_label = '°C';
		}
		if ($prefix == "fan") {
			$graph_label = "Fan speeds on $hostname";
			$vertical_label = "RPM";
		}
		if ($prefix == "in") {
			$graph_label = "Voltages on $hostname";
			$vertical_label = 'V';
		}


		$values = array();


		foreach ($NAME as $idx => $name) {
			if (startsWith($name, $prefix)) {
				echo $idx . '<br />' . $name . '<br />';
				$values[] = array($name, $idx);
			}
		}



		if (count($values) > 0) {
			$opt[$i] = "--title \"$graph_label\" --vertical-label \"$vertical_label\"";

			$def[$i] = "";
			$def[$i] .= "COMMENT:\"\\t\\t\\t   Last\\t\\t  Max\\t\\t  Avg \\n\" ";

			$j = 0;
			foreach ($values as $row) {
				$dr_name = $row[0];
				$dr_idx = $row[1];
				$dr_color = $my_colors[$j];
				$def[$i] .= "DEF:" . $dr_name . "=" . $rrdfile . ":" . $DS[$dr_idx] . ':AVERAGE ';
				$def[$i] .= "LINE:" . $dr_name . $dr_color . ":\"" . $dr_name . "\"\\t\\t ";
				$def[$i] .= "GPRINT:" . $dr_name . ":LAST:\"%.2lf \"\\t\\t ";
				$def[$i] .= "GPRINT:" . $dr_name . ":MAX:\"%4.2lf \"\\t ";
				$def[$i] .= "GPRINT:" . $dr_name . ":AVERAGE:\"%.2lf \\n\" ";
				$j++;
			}

			$i++;
		}

	}

?>


