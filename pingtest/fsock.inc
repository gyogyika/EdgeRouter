<?php

echo 'fsock.inc included.<br>';

function portopen($host, $port) {
  $connection = @fsockopen(trim($host), trim($port), $errno, $errstr, 0.1);
  if (is_resource($connection)) {
    fclose($connection);
    return true;
  }
  else {
    return false;
  }
}
