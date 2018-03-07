#!/bin/bash

# get a list of all vim scripts minus those that begin with 'x'
ls ~/scripts/*.vim ~/scripts/**/*.vim|grep -v 'x[^\/]*'|xargs

# files=""
# for file in $(ls ~/scripts/*.vim)
# do
#   if ! [[ $(basename "$file") =~ ^x ]] ; then
#     files="$files $file"
#   fi
# done
#
# echo $files
