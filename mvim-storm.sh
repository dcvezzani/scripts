#!/bin/bash

files=()
for file in "$@"; do
  files+=($(echo "scp://lightning//home/dvezzani/storm/${file}"))
done

mvim -p $(printf '%s ' "${files[@]}")
