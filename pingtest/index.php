<?php

include_once 'header';

function ping($host) {
  exec(sprintf('ping -c1 -W1 %s', escapeshellarg(trim($host))), $res, $rval);
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

  echoln ('<body>');
  echoln ('<div id="page">');
  echoln ('<div id="page-sub">');

  $name = array();
  $interface = array();
  $ips = array();

  $pingtofile = trim(file_get_contents('pingtofile'));
  $maxlines = trim(file_get_contents('maxlines'));

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

  $get = GET('kamery', 'not set');

  if ($get == '') {

  if (!file_exists('/tmp/NVRimages')) {
    mkdir('/tmp/NVRimages');
  } else {
      $files = glob('/tmp/NVRimages/*'); // get all file names
      foreach($files as $file) { // iterate files
        if (is_file($file)) {
          unlink($file); // delete file
        }
      }
    }

  $cams = file('cams');
  $camspass = trim(file_get_contents('camspass'));
  $camimages = array();

  foreach ($cams as $line_num => $cam) {
    if ((strpos($cam, '#') === 0) or (trim($cam) == '')) {
      unset($cams[$line_num]);
    } else {
        $pieces = explode('=', $cam);
        $camfilename = trim($pieces[0] . '.jpg');
        $camimages[] = $camfilename;
        $camip = trim($pieces[1]);
        exec('wget -P /tmp/NVRimages -O ' . $camfilename . ' http://' . $camspass . '@' . $camip . '/ISAPI/Streaming/channels/101/picture');
        //echo $pieces[0] . ' ';
        echoln ('<img title="' . $camfilename . '" id="' . $camfilename . '" onclick="picturezoomin(\'' . $camfilename . '\')" width="200" height="113" src="' . $camfilename . '" />');
        flush();
        if (!is_link($camfilename)) {
          if (symlink('/tmp/NVRimages/' . $camfilename, $camfilename)) {
            echobrln ($camfilename . ' symlink created.');
            flush();
          }
        }
      }
    }

  }

  echoln ('</div>');
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

  echoln ('</div>');

  echoln ('<img id="bigimage" src="" onclick="hideimage()" />');

  echoln ('<a href="?kamery"><button>Kamery</button></a>');

  echoln ('</body>');
  echoln ('</html>');

?>
