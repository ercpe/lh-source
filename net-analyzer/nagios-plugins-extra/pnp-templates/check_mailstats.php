<?php
    #
    $opt[1] = "--title \"Mail traffic on $hostname\" ";


    #
    $def[1] = "";

    $def[1] .=  "DEF:connects=$rrdfile:$DS[1]:AVERAGE " ;
    $def[1] .=  "DEF:delivered=$rrdfile:$DS[2]:AVERAGE " ;
    $def[1] .=  "DEF:rejected=$rrdfile:$DS[5]:AVERAGE " ;

    $def[1] .= "AREA:delivered#00CC00:\"Delivered mails\" ";
    $def[1] .= "STACK:rejected#CC0000:\"Rejected mails\" ";
    $def[1] .= "LINE:connects#000000:\"Connection attempts\" " ;


    #
    $opt[2] = "--title \"Rejected Mails details on $hostname\" ";

    #
    $def[2] = "";

    $def[2] .=  "DEF:rej_dnsbl=$rrdfile:$DS[6]:AVERAGE " ;
    $def[2] .=  "DEF:rej_fqdn=$rrdfile:$DS[7]:AVERAGE " ;
    $def[2] .=  "DEF:rej_penalty=$rrdfile:$DS[8]:AVERAGE " ;
    $def[2] .=  "DEF:rej_forged=$rrdfile:$DS[9]:AVERAGE " ;
    $def[2] .=  "DEF:rej_other=$rrdfile:$DS[10]:AVERAGE " ;

    $def[2] .= "AREA:rej_dnsbl#003399:\"Match on DNSBL\" ";
    $def[2] .= "STACK:rej_fqdn#0066ff:\"No FQDN\" ";
    $def[2] .= "STACK:rej_penalty#00CCFF:\"Penalty\" " ;
    $def[2] .= "STACK:rej_forged#660099:\"Forged mail\" " ;
    $def[2] .= "STACK:rej_other#9933FF:\"Other reason\" " ;

?>
