<?php

//echo 'utils.inc included.<br>';

function inifileprocess($inifile, $delimiter) {
  $result_array = array();
  $inifilelines = explode("\n", file_get_contents($inifile));
  foreach ($inifilelines as $line) {
    $nested_array = array();
    $attrline = explode($delimiter, trim($line));

    // if line is empty
    if (!$attrline[0]) continue;

    // if first char is a comment
    if ($attrline[0][0] == '#') continue;

    foreach ($attrline as $attr) {
      array_push($nested_array, $attr);
    }
    array_push($result_array, $nested_array);
  }
  return $result_array;
}

function ping($host, $interface) {
  exec(sprintf('ping -c1 -W1 -I ' . $interface . ' ' . $host), $res, $rval);
  return $rval === 0;
}

function echoln($string) {
  echo $string . PHP_EOL;
}

function echobrln($string) {
  echo $string . '<br />' . PHP_EOL;
}

function GET($index, $defaultValue) {
  return isset($_GET[$index]) ? $_GET[$index] : $defaultValue;
}