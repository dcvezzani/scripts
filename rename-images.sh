#!/bin/bash

# Get the path of the executing file
script_path=$(dirname "$(readlink -f "$0")")

# sourceFilepath='/Users/dcvezzani/DropBox/journal/images'
sourceFilepath=$(defaults read com.apple.screencapture location)

function uuid() {
  python3 -c "import uuid; print(uuid.uuid1())"
}

# uuid=$(uuidgen | tr "[:upper:]" "[:lower:]")
uuid=$(uuid | tr "[:upper:]" "[:lower:]")

if [[ ! "$1" == "" ]]; then
  uuid=$(echo "$1" | sed 's/  */-/g')
fi

cnt=$(find "$sourceFilepath" -name "${uuid}*" | wc -l | xargs)

destinationFilepath=$(cat "${script_path}/rename-images.json" | jq -r '.destinationFilepath')
outputFormat=$(cat "${script_path}/rename-images.json" | jq -r '.outputFormat')

if [[ -z $destinationFilepath ]] || [[ "null" == $destinationFilepath ]]; then
	destinationFilepath="$sourceFilepath"
fi

find -L "$sourceFilepath" -type f \( -name "Screen*" -o -name "Pasted_Image_*" \)  | sort | while read line
do
  cnt=$((cnt+1))

  filename=$(basename -- "$line")
  extension="${filename##*.}"
  prefix="${filename%.*}"
  filepath="${line%\/*}"
  cntValue=$(printf "%02d" $cnt)

  mv "${line}" "${destinationFilepath}/${uuid}-${cntValue}.${extension}"
done

if [[ -z $outputFormat ]] || [[ "null" == $outputFormat ]]; then
	outputFormat='![](images/${file})'
fi

for file in $(ls "$destinationFilepath" | grep "^$uuid"); do
  echo "$outputFormat" | perl -p -e 's/\$\{file\}/'"$file"'/g'
done | pbcopy

pbpaste
