#!/bin/zsh

total=0

while IFS= read num; do
  total=$((total + num))
done


# # Check to see if a pipe exists on stdin.
# if [ -p /dev/stdin ]; then
#   echo "pipe"
#   for num in $(cat); do
#   total=$(($total + $num))
#   done
# else
#   echo "args"
#   echo "$#"
#   while (( "$#" )); do
#   echo "$1"
#   total=$(($total + $1))
#   shift
#   done
# fi

printf "%.2f" $total | perl -pe 's/(\.[1-9])0/$1/; s/00+/0/'

