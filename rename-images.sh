#!/bin/bash

# findPath='/Users/dcvezzani/DropBox/journal/images'
findPath=$(defaults read com.apple.screencapture location)
uuid=$(uuidgen | tr "[:upper:]" "[:lower:]")

if [ ! "$1" = "" ]; then
  uuid=$(echo "$1" | sed 's/  */-/g')
fi

cnt=$(find "$findPath" -name "${uuid}*" | wc -l | xargs)

find "$findPath" -type f \( -name "Screen*" -o -name "Pasted_Image_*" \)  | sort | while read line
do
  cnt=$((cnt+1))

  filename=$(basename -- "$line")
  extension="${filename##*.}"
  prefix="${filename%.*}"
  filepath="${line%\/*}"
  cntValue=$(printf "%02d" $cnt)

  mv "${line}" "${filepath}/${uuid}-${cntValue}.${extension}"
done


for file in $(ls "$findPath" | grep "^$uuid"); do
  echo '![](images/'"$file"')'
done | pbcopy

# echo "$(ls "$findPath" | grep "^$uuid")" | pbcopy

for file in $(ls "$findPath" | grep "^$uuid"); do
  echo '![](images/'"$file"')'
done

# echo "$(ls "$findPath" | grep "^$uuid")"
