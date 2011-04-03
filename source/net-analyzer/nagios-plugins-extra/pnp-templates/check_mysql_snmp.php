<?php

    function build_def(&$out, $ds, $arr, $file) {
        foreach ($arr as $key => $value) {
            $out .= "DEF:" . $key . "=$file:" . $ds[$value] . ":AVERAGE ";
        }
    }

	$opt[1] = "--title \"Query types on $hostname\" ";
	$def[1] = "";
	build_def($def[1], $DS, array(
        "query_questions" => 1,
        "query_updates" => 2,
        "query_inserts" => 3,
        "query_selects" => 4,
        "query_deletes" => 5,
        "query_replace" => 6,
        "query_load" => 7,
    ), $rrdfile);

	$def[1] .= "AREA:query_selects#fb0000:\"SELECT\" ";
	$def[1] .= "STACK:query_deletes#fe7d05:\"DELETE\" ";
	$def[1] .= "STACK:query_inserts#fbe600:\"INSERT\" ";
	$def[1] .= "STACK:query_updates#00e10c:\"UPDATE\" ";
	$def[1] .= "STACK:query_replace#3a72ed:\"REPLACE\" ";
	$def[1] .= "STACK:query_load#5d00aa:\"LOAD\" ";
	$def[1] .= "STACK:query_questions#ffb9b7:\"Questions\" ";





	$opt[2] = "--title \"Temporary MySQL objects\" ";
	$def[2] = "";
	build_def($def[2], $DS, array(
        "temp_tables" => 8,
        "temp_tables_disk" => 9,
        "temp_files" => 10,
    ), $rrdfile);
	$def[2] .= "AREA:temp_files#08780a:\"Temp files\" ";
	$def[2] .= "STACK:temp_tables_disk#f91c2d:\"Temp tables (on disk)\" ";
	$def[2] .= "STACK:temp_tables#ffac01:\"Temp tables (in memory)\" ";



	$opt[3] = "--title \"InnoDB IO\" ";
	$def[3] = "";
	build_def($def[3], $DS, array(
        "file_fsyncs" => 11,
        "file_reads" => 12,
        "file_writes" => 13,
        "log_writes" => 14,
    ), $rrdfile);
	$def[3] .= "LINE2:file_fsyncs#0cc4ce:\"File FSyncs\" ";
	$def[3] .= "LINE2:file_reads#401e02:\"File Reads\" ";
	$def[3] .= "LINE2:file_writes#b50d26:\"File Writes\" ";
	$def[3] .= "LINE2:log_writes#fac200:\"Log Writes\" ";




	$opt[4] = "--title \"Traffic\" ";
	$def[4] = "";
	build_def($def[4], $DS, array(
        "bytes_out" => 15,
        "bytes_in" => 16,
    ), $rrdfile);
	$def[4] .= "LINE2:bytes_in#cc0000:\"Bytes IN\" ";
	$def[4] .= "LINE2:bytes_out#00cc00:\"Bytes OUT\" ";




	$opt[5] = "--title \"Hash usage\" ";
	$def[5] = "";
	build_def($def[5], $DS, array(
        "hash_adaptive" => 17,
        "hash_page" => 18,
        "hash_dictionary" => 19,
        "hash_filesystem" => 20,
        "hash_locksystem" => 21,
        "hash_recovery" => 22,
        "hash_threadhash" => 23,
    ), $rrdfile);
	$def[5] .= "AREA:hash_adaptive#7a3a54:\"Adaptive Hash Memory\" ";
	$def[5] .= "STACK:hash_page#948d3d:\"Page Hash Memory\" ";
	$def[5] .= "STACK:hash_dictionary#d2c5a3:\"Dictionary Cache Memory\" ";
	$def[5] .= "STACK:hash_filesystem#4d2f39:\"Filesystem Memory\" ";
	$def[5] .= "STACK:hash_locksystem#aa8b5d:\"Lock System Memory\" ";
	$def[5] .= "STACK:hash_recovery#ee8000:\"Recovery System Memory\" ";
	$def[5] .= "STACK:hash_threadhash#08b8b5:\"Thread Hash Memory\" ";




	$opt[6] = "--title \"Query Cache Usage\" ";
	$def[6] = "";
	build_def($def[6], $DS, array(
        "qc_hit" => 26,
        "qc_inserts" => 27,
        "qc_prunes" => 28,
        "qc_not_cached" => 29,
    ), $rrdfile);
	$def[6] .= "LINE:qc_hit#0cc4ce:\"Hits\" ";
	$def[6] .= "LINE:qc_inserts#401e02:\"Inserts\" ";
	$def[6] .= "LINE:qc_prunes#b50d26:\"Low memory prunes\" ";
	$def[6] .= "LINE:qc_not_cached#fac200:\"Not cached queries\" ";



	$opt[7] = "--title \"Query Cache Memory\" ";
	$def[7] = "";
	build_def($def[7], $DS, array(
        "qc_free" => 25,
        "qc_used" => 33,
        "qc_max" => 32,
    ), $rrdfile);
	$def[7] .= "AREA:qc_used#0cc4ce:\"Used memory\" ";
	$def[7] .= "STACK:qc_free#fac200:\"Free memory\" ";
	$def[7] .= "LINE2:qc_max#000000:\"Query Cache Size\" ";



	$opt[8] = "--title \"Connections\" ";
	$def[8] = "";
	build_def($def[8], $DS, array(
        "ctc" => 34,
        "cmax" => 35,
    ), $rrdfile);
	$def[8] .= "AREA:ctc#0cc4ce:\"Connections in use\" ";
	$def[8] .= "LINE2:cmax#000000:\"Max connections\" ";
?>
