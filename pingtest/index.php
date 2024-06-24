<?php

include_once 'header.php';
require 'fsock.php';
require 'utils.php';

  echoln ('<body>');
  echoln ('<div id="page">');
  echoln ('<div id="page-sub">');

  $names = array();
  $interfaces = array();
  $ips = array();

  $maxlines = trim(file_get_contents('maxlines'));

  $pingtofile = trim(file_get_contents('pingtofile'));
  $lines = array();
  $lines = inifileprocess($pingtofile, ' ');

  foreach ($lines as $line) {
    $names[] = $line[0];
    $interfaces[] = $line[1];
    $ips[] = $line[2];
  }

  $get = GET('kamery', 'not set');
  $wol_ip = GET('wol', 'not set');
  $ignoreping_ip = GET('ignorepingip', 'not set');

  if ($wol_ip <> 'not set') {
    echo '<div class="color-white">';
    echo 'WOL IP: ' . $wol_ip . ', ';
    $mac = getmacbyip($wol_ip);
    echo 'MAC: ' . $mac . ', ';
    if ($mac <> '') {
      $output=null;
      $retval=null;
      exec('etherwake -i "br-lan" ' . $mac, $output, $retval);
      if ($retval <> 0) echo 'etherwake is not installed.';
    }
    echo '</div>';
  }

  if ($ignoreping_ip <> 'not set') {
    //echo '$ignoreping_ip: ' . $ignoreping_ip;
  }

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

  $services = array();
  $services = inifileprocess('services',' ');

  $tableheader = '<tr><th>Num</th><th>Device</th><th>Interface</th><th>IP address</th><th>Ping status</th><th>Services</th></tr>';
  echoln ('<table>');
  echoln ($tableheader);
  foreach ($ips as $num => $ip) {
    if ( ($ip <> $ignoreping_ip) and ($ignoreping_ip <> 'all') ) {
      $ping = (ping($ip, $interfaces[$num])) ? 'ping OK' : 'NO ping';
      $pingclass = ($ping == 'ping OK') ? 'online' : 'offline';
    }
    else {
      $pingclass = 'ignored';
      $ping = 'Ignored';
    }
    
    $detected_services = '';

    if ($ping <> 'NO ping') {
      foreach ($services as $service) {
        $serviceport = $service[0];
        $servicename = $service[1];
        $servicename2 = $service[2];
          if (portopen($ip, $serviceport)) {
            $detected_services .= '<span title="' . $servicename . '">' . $servicename2 . '</span>' . ' ';
          }
      }
    }

    echoln ('<tr><td>' . ($num + 1) . '</td><td><a href="http://' . $ip . '" target="_blank">' . $names[$num] . '</a></td><td>' . $interfaces[$num] . '</td><td><a href="?wol=' . $ip . '">' . $ip . '</a></td><td class="' . $pingclass . '"><a href="?ignorepingip=' . $ip . '">' . $ping . '</a></td><td>' . $detected_services . '</td></tr>');
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

  $loggers = inifileprocess('loggers',' ');
  foreach ($loggers as $logger) {
    $loggername = $logger[0];
    $loggerurl = $logger[1];
    echobrln ('<a target="_blank" href="' . $loggerurl . '"><button>' . $loggername . '</button></a>');
  }

  //echoln ('<a href="?kamery"><button>Kamery</button></a>');

  echoln ('</body>');
  echoln ('</html>');
?>
