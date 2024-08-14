#!/bin/bash

TMP="/tmp/root/"

mkdir $TMP

while read -r LINE
do

  cp -r "$LINE" $TMP

done < "/root/copytotmp"
