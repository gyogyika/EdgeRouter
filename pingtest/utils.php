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

function getmacbyip($wol_ip) {
  $result_mac = '';
  $dhcp_file = '/etc/config/dhcp';
  $dhcp_lines = file($dhcp_file);
  $dhcp_lines_count = count($dhcp_lines) - 1;

  $i = 0;
  while ($i <= $dhcp_lines_count) {
    //echo $dhcp_lines[$i] . '<br>';
    if (strpos($dhcp_lines[$i], 'config host') !== false) { // if string 'config host' exists

      $i++;
      $mac = '';
      $ip = '';
      while (strpos($dhcp_lines[$i], 'config host') === false) {

        if (strpos($dhcp_lines[$i], ' mac ') !== false) {
          $mac = $dhcp_lines[$i];
          $mac = getBetween($mac, "'", "'");
        }

        if (strpos($dhcp_lines[$i], ' ip ') !== false) {
          $ip = $dhcp_lines[$i];
          $ip = getBetween($ip, "'", "'");
        }
        $i++;
        if ($i >= $dhcp_lines_count) break;
      }
      if ($ip == $wol_ip) {
        $result_mac = $mac;
        break;
      }
      $i--;
    }
    $i++;
  }

  return $result_mac;
}

function ping($host, $interface) {
  //exec(sprintf('ping -c1 -W1 -I ' . $interface . ' ' . $host), $res, $rval);
  exec(sprintf('ping -c1 -W1 ' . $host), $res, $rval);

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


function getBetween($string, $start = "", $end = ""){
  if (strpos($string, $start)) { // required if $start not exist in $string
    $startCharCount = strpos($string, $start) + strlen($start);
    $firstSubStr = substr($string, $startCharCount, strlen($string));
    $endCharCount = strpos($firstSubStr, $end);
    if ($endCharCount == 0) {
      $endCharCount = strlen($firstSubStr);
    }
    return substr($firstSubStr, 0, $endCharCount);
  }
  else {
    return '';
  }
}

