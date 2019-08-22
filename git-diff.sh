#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: git-diff ed7b2772f6072a142f138231b71d8633bf56f738"
	echo "Usage: git-diff ed7b2772f6072a142f138231b71d8633bf56f738~2"
	exit
fi

targetFiles="$2"
if [ -z "$targetFiles" ]; then
  targetFiles="."
fi


if [[ "$1" =~ \~[0-9]*$ ]]; then 
  cmt=$(echo "$1" | sed 's/\([^\~]*\)\~\([0-9]*\)$/\1/g')
  idx=$(echo "$1" | sed 's/\([^\~]*\)\~\([0-9]*\)$/\2/g')
  echo ">>> Comparing ${cmt}~$(($idx+1)) > ${cmt}~$(($idx)) -- $targetFiles"
  git diff "${cmt}~$(($idx+1))" "${cmt}~$(($idx))" -- "$targetFiles"
else
  echo ">>> Comparing ${1}~1 $1 -- $targetFiles"
  git diff "${1}~1" "$1" -- "$targetFiles"
fi
