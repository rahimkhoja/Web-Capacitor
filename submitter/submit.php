#!/usr/bin/env php
<?php

if (php_sapi_name() !== 'cli') {
    error_log('This CLI script can only be executed from the command line.');
    die('CLI access only.');
}

// cUrl handler to ping the Sitemap submission URLs for Search Engines
function myCurl($url, $search){
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $curldata = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    $bingsuccess='Thanks for submitting your Sitemap.';
    $googlesuccess='Your Sitemap has been successfully';

    echo $search." Sitemaps has been pinged (return code: {$httpCode}).\n";
    $text = $search." Sitemaps has been pinged return code: {".$httpCode."}";
    if (strpos($curldata, $bingsuccess) !== false) {
        echo "Sitemap Successfully Submitted to Bing!\r\n\r\n";
        $text = "Sitemap Successfully Submitted to Bing!";
    }

    if (strpos($curldata, $googlesuccess) !== false) {
        echo "Sitemap Successfully Submitted to Google!\r\n\r\n";
        $text = "Sitemap Successfully Submitted to Google!";
    }
    return $httpCode;
}

echo "Starting site submission at ".date('Y-m-d H:i:s')."\r\n\r\n";
// $argv[0] contains the name of this script.
// We just want the args, so we skip the script name
array_shift($argv);
foreach ($argv as $s) {
    if(filter_var($s, FILTER_VALIDATE_URL) === false) {
        echo "Invalid URL: ".escapeshellarg($s)." -- skipping\n";
        continue;
    }
    echo "Submitting URL: $s\r\n\r\n";
    
    //Google
    echo "Submitting to Google\r\n";
    $url = "http://www.google.com/webmasters/sitemaps/ping?sitemap=".$s;
    $returnCode = myCurl($url,"Google");

    //Bing / MSN
    echo "Submitting to Bing\r\n";
    $url = "http://www.bing.com/webmaster/ping.aspx?siteMap=".$s;
    $returnCode = myCurl($url, "Bing/MSN");
}
echo "Completed at ".date('Y-m-d H:i:s')."\n\r\n";
