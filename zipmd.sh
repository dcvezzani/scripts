#!/bin/bash

if [ "$1" == "" ]; then
  echo "Usage: ./scripts/zipmd.sh {source file}"
  echo "Example: ./scripts/zipmd.sh /Users/dcvezzani/Dropbox/journal/current/20210903-kcw-ldsc-86.md"
  echo
  echo "Usage: ./scripts/zipmd.sh {source file} {image 1} {image 2} {image 3} ..."
  echo "Example: ./scripts/zipmd.sh /Users/dcvezzani/Dropbox/journal/current/20210903-kcw-ldsc-86.md /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-03.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-04.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-02.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-01.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-05.png"
  echo
  
  exit 1
fi

file="$1"
# file="/Users/dcvezzani/Dropbox/journal/current/20210903-kcw-ldsc-86.md"

fileNoPath="${file/*\//}"
fileJustPath="${file%/*}"

# echo "$file"
# echo "$fileNoPath"
# echo "$fileJustPath"
# exit 1

images="${@:2}"
timestamp=$(date +%s)

imageLength=$(echo "$images" | wc -c | xargs)
if (( imageLength < 2 )); then
  images=$(perl -n -e 'print if m/\]\(images\/[^\.]*\.png\)/' "$file" | perl -p -e 's/^[^\(]*\(([^\)]+)\)$/\/Users\/dcvezzani\/Dropbox\/journal\/\1/g' | xargs)
else
  echo "images provided on command line ${imageLength}"
fi

# zip -d "/Users/dcvezzani/Dropbox/journal/current/${fileNoPath}.zip" $file
# zip --junk-paths --freshen -u "/Users/dcvezzani/Dropbox/journal/current/${fileNoPath}.zip" $file

mkdir -p "/tmp/zipmd/${timestamp}/images"

cp $file "/tmp/zipmd/${timestamp}"

# cp /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-03.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-04.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-02.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-01.png /Users/dcvezzani/Dropbox/journal/images/0fa38ac5-c899-4e34-b7a1-eb279b9bdfa0-05.png "/tmp/zipmd/${timestamp}/images"

cp $images "/tmp/zipmd/${timestamp}/images"

# Inside parentheses, and therefore a subshell . . .
(
echo
echo "Archiving files..."
echo
cd "/tmp/zipmd/${timestamp}"
zip -ru "/Users/dcvezzani/Downloads/${fileNoPath}.zip" .
)

if [ -d "/tmp/zipmd/${timestamp}" ]; then
  echo
  echo "Cleaning up /tmp..."
  echo
  ls -R "/tmp/zipmd/${timestamp}"
  echo
  echo "Really delete these files? ('yes' to confirm)"; read response

  if [ "$response" == "yes" ]; then
    rm -rf "/tmp/zipmd/${timestamp}"
  fi
fi

echo
echo "Verifying archive..."
echo
unzip -t "/Users/dcvezzani/Downloads/${fileNoPath}.zip"
echo
echo "DONE"
