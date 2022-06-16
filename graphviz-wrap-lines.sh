#!/bin/bash

# IFS=$'\n' lines=($(echo -e "$1" | sed -r 's/\n/<BR ALIGN="LEFT"\/>/g; s/(.{40})/\1\n/g'))
# 
# cnt=0
# for line in "${lines[@]}"; do
# # echo "$cnt: $line"
# if [[ $cnt == 0 ]]; then
# echo "$line"
# else
# echo "<BR ALIGN="LEFT"/>$line"
# fi
# ((cnt++))
# done


cmd=$(cat << EOL
cd ~/scripts;
PBCOPY="$PBCOPY" PREFIX="$PREFIX" SUFFIX="$SUFFIX" node graphviz-wrap-lines.js "$1" "$2";
EOL
)

cat << EOL >&2
CMD ================
$cmd
====================

EOL

( 
output=$(eval "$cmd")

if [ "$PBCOPY" = "y" ]; then
echo -e "$output" | pbcopy
else
echo -e "$output"
fi
)
