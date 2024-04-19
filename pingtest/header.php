<!DOCTYPE html>
<html lang="en">
<head>

<?php
$title = 'Ping - ';
$title .= trim(file_get_contents('name'));
echo '<title>' . $title. '</title>';
?>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="icon" type="image/png" href="favicon.png" sizes="16x16">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="refresh" content="60" />
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
body {
  Font-family: Arial;
  Font-size: 1em;
}

#page {
  opacity: 1.0;
}

table {
  border: 1px solid black;
  /*width: 700px;*/
  float: left;
  /*margin-right: 5px;*/
  /*margin-bottom: 5px;*/
  padding: 0px;
}

td {
  /*padding-top: 10px;*/
  padding-left: 10px;
  margin: 0px;
}

img {
  background-image: url('nocam.png');
  background-size: 60px;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  /*transition: transform 0.25s ease;*/
  /*transition: top 0.25s ease;*/
  cursor: zoom-in;
}

#webcams {
  /*clear: both;*/
}

tr:hover {
  background-color: rgba(2,100,161, 0.2);
}

.error-color {
  color: red;
  border: 2px solid red;
}

th {
  background-color: #e8e8e8;
}

td:first-child {
  /*width: 100px;*/
  text-align: right;
}

td.log {
  height: 100px;
  width: 10px;
  vertical-align: bottom;
}

.online {
  /*color: #99ff99;*/
  background-color: #99FF99;
}

.offline {
  /*color: #ff9999;*/
  background-color: #FF9999;
}

#bigimage {
  background-image: none;
  position: absolute;
  top: 0px;
  left: 0px;
  width: 100vw;
  height: 100vh;
  display: none;
  cursor: zoom-out;
  object-fit: scale-down;
}
</style>

<script>
function picturezoomin(imagefile) {
  //alert(imagefile);
  elem = document.getElementById('bigimage');
  elem.src = imagefile;
  elem.style.display = 'initial';
  page = document.getElementById('page');
  page.style.opacity = "0.4";
  //page.style.backgroundColor = "black";
}

function hideimage() {
  //alert('hideimage');
  elem = document.getElementById('bigimage');
  elem.style.display = 'none';
  page = document.getElementById('page');
  //page.style.backgroundColor = "initial";
  page.style.opacity = "initial";
}

</script>

</head>
