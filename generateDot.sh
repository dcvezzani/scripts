#!/bin/bash

if [ -z ${1+x} ]; then
	echo "Usage: ./generateDot.sh /path/someFileName.txt"
else
	fullFileName=$(basename "$1")
	prefix=${fullFileName%.*}
	cat "$1"| dot -Tpng -Gdpi=150 -o "${prefix}.png" && open "${prefix}.png"
	# cat "$1"| neato -Tpng -o "${prefix}.png" && open "${prefix}.png"
fi

