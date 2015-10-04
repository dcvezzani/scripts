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


function usage(){
  echo "======================================
Uncompress a Pdf file

Usage: 
~/scripts/pdf-uncompress-pdf-file.sh ~/Downloads/wip01/invoice.pdf
~/scripts/pdf-uncompress-pdf-file.sh ~/Downloads/wip01/invoice.pdf ~/Downloads/wip01/invoice.unc.pdf

# include variable to suppress user prompt
PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT=true ~/scripts/pdf-uncompress-pdf-file.sh ~/Downloads/wip01/invoice.pdf
PDF_UNCOMPRESS_PDF_FILE_EDIT_PDF=true PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT=true ~/scripts/pdf-uncompress-pdf-file.sh ~/Downloads/wip01/invoice.pdf
"
}

if [ $# -eq 0 ]; then
  usage
  exit 2
fi

if [ ! -e "$1" ]; then
  echo "File doesn't seem to exist.  Check the supplied location: 
$1
"
  usage
  exit 2
fi

msg=''
_output=''
if [ $# -eq 1 ]; then
  _output=$(mktemp "/tmp/$(basename $1).XXXXXXXXXXXXXXX" || { echo "Failed to create temp file"; exit 1; })
elif [ $# -eq 2 ]; then
  _output="$2"
fi

echo "pdftk $1 output $_output uncompress"
pdftk "$1" output $_output uncompress

ans=''
if [ $# -eq 2 ]; then
  ans='n'
elif [ ! -z "$PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT" ] && [ "$PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT" == 'true' ]; then
  msg="${msg}\nFound environment variable, PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT: ${PDF_UNCOMPRESS_PDF_FILE_NO_PROMPT}"
  ans='y'
else
  read -e -p "Do you want to update '$1' with the uncompressed version? (y/n): " ans
fi

case "$ans" in
y|Y)
  mv $_output "$1"
  msg="${msg}\nUncompressed Pdf file was successfully created and applied to source Pdf: $1"
  _dest_file="$1"
  ;;
n)
  msg="${msg}\nUncompressed Pdf file was successfully created: ${_output}"
  _dest_file="$_output"
  ;;
*)
  usage
  exit 2
  ;;
esac

echo -e "$msg"

if [ ! -z "$PDF_UNCOMPRESS_PDF_FILE_EDIT_PDF" ] && [ "$PDF_UNCOMPRESS_PDF_FILE_EDIT_PDF" == 'true' ]; then
  mvim "$_dest_file"
fi

