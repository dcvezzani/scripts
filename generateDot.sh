#!/bin/bash

if [ -z ${1+x} ]; then
	echo "Usage: ./generateDot.sh /path/someFileName.txt"
else
	fullFileName=$(basename "$1")
	prefix=${fullFileName%.*}
	cat "$1"| dot -Tpng -o "${prefix}.png" && open "${prefix}.png"
fi

