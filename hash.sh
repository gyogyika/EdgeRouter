#!/bin/sh

echo "=""$1""="
HASH=$(printf "%s" "$1" | md5sum)
#echo HASH:"$HASH"
HASH=$(echo "$HASH" | cut -c 1-32)
echo HASH: "$HASH"
