#!/bin/bash

if [ $# -gt 0 ]; then
  case "$1" in
  'journal')
    spath=/Users/davidvezzani/Dropbox/journal
    ;;
  'hive')
    spath=/Users/davidvezzani/reliacode/crystal_commerce/hive
    ;;
  'catalog')
    spath='/Users/davidvezzani/reliacode/crystal_commerce/hive-inventory /Users/davidvezzani/reliacode/crystal_commerce/hive-inventory'
    ;;
  'core')
    spath=/Users/davidvezzani/reliacode/crystal_commerce/core
    ;;
  'cc')
    spath=/Users/davidvezzani/reliacode/crystal_commerce
    ;;
  'all')
    spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal'
    ;;
  'vim')
    spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal'
    dtype='vim'
    orderby='date'
    ;;
  esac
fi

if [ -z "$spath" ]; then
  spath=/Users/davidvezzani/Dropbox/journal/current
fi

# if [ -z "$verbose" ]; then
#   verbose=false
# fi

if [ -z "$orderby" ]; then
  orderby='filename'
fi

if [ -z "$dtype" ]; then
  dtype='basic'
  # dtype='vim'
fi

echo "./journal-latest.sh journal"
echo "./journal-latest.sh hive"
echo "./journal-latest.sh catalog"
echo "./journal-latest.sh core"
echo "./journal-latest.sh cc"
echo "./journal-latest.sh all"
echo "./journal-latest.sh vim"
echo ""
echo "all journal: spath=/Users/davidvezzani/Dropbox/journal ./journal-latest.sh"
echo "all core: spath=/Users/davidvezzani/reliacode/crystal_commerce/core ./journal-latest.sh"
echo "all catalog: spath='/Users/davidvezzani/reliacode/crystal_commerce/hive-inventory /Users/davidvezzani/reliacode/crystal_commerce/hive-inventory' ./journal-latest.sh"
echo "all hive: spath=/Users/davidvezzani/reliacode/crystal_commerce/hive ./journal-latest.sh"
echo "all cc: spath=/Users/davidvezzani/reliacode/crystal_commerce ./journal-latest.sh"
echo "all: spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal' ./journal-latest.sh"
echo "all vim: spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal' ./journal-latest.sh"
echo ""
echo "spath: ${spath}"
# echo "verbose: ${verbose}"
echo "orderby: ${orderby}"
echo "dtype: ${dtype}"
echo -e "===============\n"

# if [ "$verbose" == "true" ]; then
#   #filenameFilter='-exec stat -c "%n %y" {} ;'
#   filenameFilter='-exec stat -l {} ;'
# else
#   filenameFilter='-exec basename {} ;'
# fi

function lineFormat(){
  file=$1
  details=$2
  if [ "$orderby" == "filename" ]; then
    res="${file##*\/},$details,$file"
  else
    res="$details,${file##*\/},$file"
  fi
  echo $res
}


if [ "$dtype" == "vim" ]; then
  searchResults=$(find -H $spath -name '.*' ! -path '*/.*/*' -type f -mtime -1)
else
  searchResults=$(find -H $spath ! -name '.*' ! -path '*/.*' -type f -mtime -1)
fi

#find -H $spath ! -name '.*' -maxdepth 5 -type f -mtime -1 $filenameFilter
#for file in $(find -H $spath ! -name '.*' -type f -mtime -1 -exec basename {} \; | sort ); do
res01=$(for file in $searchResults; do
  details=$(stat -f'%Sm' -t '%Y-%m-%dT%H%M' $file)
  echo $(lineFormat $file $details)
done | sort)

for file in $res01; do
  echo $file | sed 's/\(-[0-9]\{2\}\)T\([0-9]\{2\}\)\([0-9]\{2\}\)/\1 \2:\3 /g'
done | column -t -s','

echo ""
# ls -${ls_options} $spath | grep -v '.sw' | grep -v '^d' | tail -n10
