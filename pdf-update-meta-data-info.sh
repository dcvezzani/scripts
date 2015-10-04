#!/bin/bash

echo "here i am: $@" >> /var/tmp/myScript.log

path_to_executable=$(which pdftk)
if [ ! -x "$path_to_executable" ] ; then
  echo "Unable to locate pdftk tool; loading environment"

  # so that AppleScript can set up environment; runs in 'sh' shell by default
  # file references should have been translated from POSIX paths in the AppleScript
  # already
  source ~/.zshrc
fi
# path_to_executable=$(which pdftk)
# echo "path_to_executable: ${path_to_executable} $@" >> /var/tmp/myScript.log

function usage(){
  echo "======================================
Update Meta Data for a Pdf file
currently only processes 1 file at a time

Usage: 
~/scripts/pdf-update-meta-data-info.sh ~/Downloads/wip01/invoice.pdf
"
}

if [ $# -eq 0 ]; then
  usage
  exit 2
fi

for pdf_file in "$@"; do
  if [ ! -e "$pdf_file" ]; then
    echo "File doesn't seem to exist.  Check the supplied location: 
$pdf_file
"
    usage
    exit 2
  fi

  msg=''
  _output=$(mktemp "/tmp/$(basename $pdf_file).XXXXXXXXXXXXXXX" || { echo "Failed to create temp file"; exit 1; })
  _title=$(mktemp "/tmp/$(basename $pdf_file).title.XXXXXXXXXXXXXXX" || { echo "Failed to create temp file"; exit 1; })

  # echo "created tmp files: _output: ${_output}, _title: ${_title} $@" >> /var/tmp/myScript.log

  filename=$(basename $pdf_file)
  title_value=$(echo ${filename%.*} | tr -c '[[:alnum:]]' ' ' | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')

  # echo "title_value: ${title_value} $@" >> /var/tmp/myScript.log

  echo "InfoBegin
  InfoKey: Title
  InfoValue: $title_value
  " > $_title

  # cat $_title >> /var/tmp/myScript.log

  # InfoBegin
  # InfoKey: Author
  # InfoValue: David C. Vezzani


  pdftk $pdf_file update_info $_title output $_output
  # pdftk /Users/davidvezzani/Documents/journal/10-oct-2015/x20151001-enerbank-loan-forms-for-david-vezzani-bbb.pdf update_info /tmp/x20151001-enerbank-loan-forms-for-david-vezzani-bbb.pdf.title.mMtcFYwGFK5LwFI output /tmp/x20151001-enerbank-loan-forms-for-david-vezzani-bbb.pdf.0u1NLymvDDZJKpw


  # echo "Checking status for ${1}: $?; $@" >> /var/tmp/myScript.log
  if [ "$?" == "0" ]; then
    # echo "success $@" >> /var/tmp/myScript.log
    mv $_output $pdf_file
  else
    echo "Cannot update metadata" 1>&2
    echo "$?"
    # echo "Cannot update metadata: $?; $@" >> /var/tmp/myScript.log
    exit 1  
  fi
done

echo "$?"

