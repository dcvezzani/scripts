#!/bin/bash

# get a list of all vim scripts minus those that begin with 'x'
# ls -R ~/scripts/*.vim  |grep -v '\/_[^\/]*'|xargs
find ~/scripts -name '*.vim' | grep -vE '\/_[^\/\.]+\.vim$' | xargs

# files=""
# for file in $(ls ~/scripts/*.vim)
# do
#   if ! [[ $(basename "$file") =~ ^x ]] ; then
#     files="$files $file"
#   fi
# done
#
# echo $files
