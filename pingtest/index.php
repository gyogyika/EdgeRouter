<?php

include_once 'header';

function ping($host) {
  exec(sprintf('ping -c1 -W1 %s', escapeshellarg(trim($host))), $res, $rval);
  return $rval === 0;
}

function echoln($string) {
  echo $string . PHP_EOL;
}

  $name = array();
  $interface = array();
  $ips = array();

  $pingtofile = trim(file_get_contents('./pingtofile'));
  $maxlines = trim(file_get_contents('./maxlines'));

  $lines = file($pingtofile);

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

  echoln ('<body>');

  $linecount = $maxlines;

  $tableheader = '<tr><th>Num</th><th>Device</th><th>Interface</th><th>IP address</th><th>Ping status</th>';
  echoln ('<table>');
  echoln ($tableheader);
  foreach ($ips as $num => $ip) {
    $ping = (ping($ip)) ? 'ping OK' : 'NO ping';
    $pingclass = ($ping == 'ping OK') ? 'online' : 'offline';
    echoln ('<tr><td>' . ($num + 1) . '</td><td>' . $name[$num] . '</td><td>' . $interface[$num] . '</td><td>' . $ip . '</td><td class="' . $pingclass . '">' . $ping . '</td></tr>');
    if ($linecount < sizeof($ips)) {
      if (($num+1) == $linecount) {
        echoln ('</table>');
        echoln ('<table>');
        echoln ($tableheader);
        $linecount = $linecount + $maxlines;
      }
    }
    if ($ping == 'NO ping') flush();
  }
  echoln ('</table>');

  echoln ('</body>');
  echoln ('</html>');

?>
