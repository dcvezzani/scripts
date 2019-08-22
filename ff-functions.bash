#!/bin/bash


read -r -d '' sedParams <<'EOF'
s/dist //g; s/node_modules //g; s/target //g; s/package[^\.]*\.json //g
EOF

columnWidth=120

ffi() {
if [ "$1" == "" ]; then echo "Usage: ffi <term>, ffl <term>, ffn <term>"; return; fi
ls -1 | xargs | sed "$sedParams" | xargs grep -r "$1" | grep -v 'target'
}

ffl() {
if [ "$1" == "" ]; then echo "Usage: ffi <term>, ffl <term>, ffn <term>"; return; fi
ls -1 | xargs | sed "$sedParams" | xargs grep -rl "$1" | grep -v 'target'
}

ffn() {
if [ "$1" == "" ]; then echo "Usage: ffi <term>, ffl <term>, ffn <term>"; return; fi
ls -1 | xargs | sed "$sedParams" | xargs grep -rn "$1" | grep -v 'target' | cut -c 1-"$columnWidth"
}

fl() {
if [ "$1" == "" ]; then echo "Usage: fl <term>"; return; fi
dirList=$(ls -1 | xargs | sed "$sedParams")
find -H $(echo $dirList | xargs) -name "*$1*" | grep -v 'target'
}

