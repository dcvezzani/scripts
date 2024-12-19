#!/bin/bash

cd ~/scripts

searchTerm="$1"
grepFlags="$2"

# searchTerm="highlight"
# grepFlags="n"

CMD=$(cat << EOL
grep -rlE "${searchTerm}" | grep -vE 'node_modules\/|Binary|\.git\/|\.sw[a-z]' | xargs grep -r${grepFlags}E "${searchTerm}"
EOL
)

eval "$CMD"

# /Users/dcvezzani/scripts/grep_cmd.sh "highlight" "n"
#
#
# grep -rnE "highlight" | grep -vE 'node_modules\/|Binary|\.git\/' | perl -p -e 's/^([^:]+:[^:]+):(.*)$/$1ç -------- ç$2/g' | column -t -s'ç'
# grep -rnE "highlight" | grep -vE 'node_modules\/|Binary|\.git\/' | perl -p -e 's/^([^:]+):([^:]+):(.*)$/$1ç$2ç$3/g' | column -t -s'ç'
# 
