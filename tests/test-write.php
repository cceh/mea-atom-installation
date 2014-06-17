<?php

header('Content-Type: text/plain');

$root = "atom-2.x";
if (!is_dir($root)) {
	$root = "atom-2.0.1";
}
$dir = $root . '/test';
$file = $dir . '/file.txt';
$content = 'TEST';

echo "Testing in '" . $root . "'\n\n";

unlink($file);
rmdir($dir);

echo "Can mkdir... ";
echo (int)mkdir($dir);
echo "\n";

echo "Can write content... ";
echo (int)file_put_contents($file, $content);
echo "\n";

$new_content = file_get_contents($file);

echo "\n";
echo "Original content: '" . $content . "'\n";
echo "Read content: '". $new_content . "'\n";

echo "\n";
echo "Finished test";
