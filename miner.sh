#!/usr/bin/php
<?php
$n = 8; 
$maxRequests = 10;
$url = "https://rt.pornhub.com/model/danya-kraster"; 
$dataDir = __DIR__;
$bashScriptPath = $dataDir . "/monitor_$n.sh";

$scriptLines = [
    "#!/bin/bash",
    "",
    "COUNT_FILE=\"$dataDir/request_count.txt\"",
    "INFO_FILE=\"$dataDir/info.txt\"",
    "",
    "if [ ! -f \$COUNT_FILE ]; then echo 0 > \$COUNT_FILE; fi",
    "",
    "COUNT=\$(cat \$COUNT_FILE)",
    "",
    "if [ \$COUNT -ge $maxRequests ]; then exit 0; fi",
    "",
    "curl -s -o /dev/null -w \"%{http_code}\" $url",
    "",
    "if [ \$? -eq 0 ]; then echo \"успех !!! \$(date)\" >> \$INFO_FILE; fi",
    "",
    "COUNT=\$((COUNT+1))",
    "echo \$COUNT > \$COUNT_FILE"
];

$scriptContent = implode("\n", $scriptLines);
file_put_contents($bashScriptPath, $scriptContent);
chmod($bashScriptPath, 0755);

$cron_line = "*/$n * * * * " . escapeshellcmd($bashScriptPath) . " >/dev/null 2>&1\n";

$currentCron = shell_exec("crontab -l 2>/dev/null");

if (strpos($currentCron, $bashScriptPath) === false) {
    file_put_contents("/tmp/cron2.tmp", $currentCron . $cron_line);
    exec("crontab /tmp/cron2.tmp");
    unlink("/tmp/cron2.tmp");
}

$processFile = $dataDir . "/.process_" . md5(uniqid()) . ".pid";
file_put_contents($processFile, getmypid());

?>