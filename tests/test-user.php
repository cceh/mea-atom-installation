<?php

header('Content-Type: text/plain');

$euid = posix_geteuid();
$processUser = posix_getpwuid($euid);

echo "User euid = " . $euid . "\n";
echo "User name = " . $processUser['name'] . "\n";
