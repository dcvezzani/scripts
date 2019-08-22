#!/bin/bash

findPath="$1"
if [ -z "$findPath" ]; then
	echo "Usage: ff ./src promo-group-transform.xqy"
	exit
fi

fileName="$2"
if [ -z "$fileName" ]; then
	echo "Usage: ff ./src promo-group-transform.xqy"
	exit
fi

# echo "CMD: find \"$findPath\" -name \"'$fileName'\""
find "$findPath" -name "$fileName"
