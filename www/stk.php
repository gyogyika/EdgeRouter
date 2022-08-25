<?php

include_once 'header';

function ping($host) {
  exec(sprintf('ping -c1 -W1 %s', escapeshellarg(trim($host))), $res, $rval);
  return $rval === 0;
}

  $name = array();
  $interface = array();
  $ips = array();

  $lines = file('../pingto2');

  foreach ($lines as $line_num => $line) {
    if ((strpos($line, '#') === 0) or (trim($line) == '')) {
      unset($lines[$line_num]);
    } else {
        $pieces = explode(' ', $line);
        #echo $pieces[2] . "<br />\n";
        $name[] = trim($pieces[0]);
        $interface[] = trim($pieces[1]);
        $ips[] = trim($pieces[2]);
      }
  }
  
  echo '<body>';
  echo '<table>';
  echo '<tr><th>Device</th><th>Interface</th><th>IP address</th><th>Ping status</th>' . PHP_EOL;
  foreach ($ips as $num => $ip) {
    $ping = (ping($ip)) ? 'ping OK' : 'NO ping';
    $pingclass = ($ping == 'ping OK') ? 'online' : 'offline';
    echo '<tr><td>' . $name[$num] . '</td><td>' . $interface[$num] . '</td><td>' . $ip . '</td><td class="' . $pingclass . '">' . $ping . '</td></tr>' . PHP_EOL;
  }

  echo '</table>' . PHP_EOL;
  echo '</body>' . PHP_EOL;
  echo '</html>' . PHP_EOL;

?>

