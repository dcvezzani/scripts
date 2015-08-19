#!/bin/bash

files=""
for file in $(ls ~/scripts/*.vim)
do
  if ! [[ $(basename "$file") =~ ^x ]] ; then
    files="$files $file"
  fi
done

echo $files
