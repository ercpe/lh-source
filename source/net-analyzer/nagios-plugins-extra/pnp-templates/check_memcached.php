<?php
    $opt[1] = "--title \"Memcached commands on $hostname\" ";
    $def[1] = "";
    $def[1] .=  "DEF:x0=$rrdfile:$DS[1]:AVERAGE " ;
    $def[1] .=  "DEF:x1=$rrdfile:$DS[2]:AVERAGE " ;
    $def[1] .=  "DEF:x2=$rrdfile:$DS[3]:AVERAGE " ;
    $def[1] .= "LINE:x0#00CC00:\"Get commands\" ";
    $def[1] .= "LINE:x1#CC0000:\"Set commands\" ";
    $def[1] .= "LINE:x2#0000DD:\"Flush commands\" ";


    $opt[2] = "--title \"Memcached cache command stats on $hostname\" ";
    $def[2] = "";
    $def[2] .=  "DEF:x3=$rrdfile:$DS[4]:AVERAGE " ;
    $def[2] .=  "DEF:x4=$rrdfile:$DS[5]:AVERAGE " ;
    $def[2] .=  "DEF:x5=$rrdfile:$DS[6]:AVERAGE " ;
    $def[2] .=  "DEF:x6=$rrdfile:$DS[7]:AVERAGE " ;
    $def[2] .= "LINE:x3#00CC00:\"Get Hits\" ";
    $def[2] .= "LINE:x4#CC0000:\"Get Misses\" ";
    $def[2] .= "LINE:x5#66FFFF:\"Delete Hits\" ";
    $def[2] .= "LINE:x6#6666FF:\"Delete Misses\" ";

    $opt[3] = "--title \"Memcached cache items on $hostname\" ";
    $def[3] = "";
    $def[3] .=  "DEF:x7=$rrdfile:$DS[8]:AVERAGE " ;
    $def[3] .= "LINE:x7#00CC00:\"Items in cache\" ";


    $opt[4] = "--title \"Memcached cache size on $hostname\" ";
    $def[4] = "";
    $def[4] .=  "DEF:x8=$rrdfile:$DS[9]:AVERAGE " ;
    $def[4] .=  "DEF:x9=$rrdfile:$DS[10]:AVERAGE " ;
    $def[4] .= "AREA:x8#00CC00:\"Bytes in cache\" ";
    $def[4] .= "LINE:x9#000000:\"Max size of cache\" ";

?>
