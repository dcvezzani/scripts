#!/bin/bash

while (( "$#" )); do
  mtch=$(echo "$1" | sed 's/\(by\):.*/\1/g; s/\(term\):.*/\1/g; s/\(range:days\{0,1\}\):.*/range:days/g')
  case $mtch in
    'by')
      orderby=$(echo "$1" | sed 's/by:\(.*\)/\1/g')
      ;;

    'term')
      searchTerm=$(echo "$1" | sed 's/term:\(.*\)/\1/g')
      ;;

    'list:files:xargs')
      listFiles=1
      cmdXargs=1
      ;;

    'list:files')
      listFiles=1
      ;;

    'range:days')
      rangeDays=$(echo "$1" | sed 's/^range:days\{0,1\}:\([0-9]*\)/\1/g')

      #echo ">> $rangeDays"
      if [ ! -z "$rangeDays" ] && [ $rangeDays -gt 5 ]; then
        rangeDays=1
      fi
      ;;
    *)
      case "$1" in
      'journal')
        spath=/Users/davidvezzani/Dropbox/journal
        ;;
      'wiki')
        spath=/Users/davidvezzani/reliacode/crystal_commerce/core.wiki
        ;;
      'scripts')
        spath=/Users/davidvezzani/scripts
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
        spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal /Users/davidvezzani/scripts'
        ;;
      'vim')
        spath='/Users/davidvezzani/reliacode/crystal_commerce /Users/davidvezzani/Dropbox/journal /Users/davidvezzani/scripts'
        dtype='vim'
        orderby='date'
        ;;
      esac
      ;;
  esac

  shift
done

if [ -z "$spath" ]; then
  spath=/Users/davidvezzani/Dropbox/journal/current
fi

# if [ -z "$verbose" ]; then
#   verbose=false
# fi

if [ -z "$searchTerm" ]; then
  searchTerm=''
fi

if [ -z "$orderby" ]; then
  orderby='filename'
fi

if [ -z "$dtype" ]; then
  dtype='basic'
  # dtype='vim'
fi

if [ -z "$rangeDays" ]; then
  rangeDays=1
fi

if [ -z "$listFiles" ]; then
  listFiles=0
fi

if [ -z "$cmdXargs" ]; then
  cmdXargs=0
fi

if [ "$listFiles" == "0" ]; then
echo "~/scripts/work-latest.sh journal"
echo "alias: wl journal; same as '~/scripts/work-latest.sh'"
echo "alias: wl-cache; same as 'cat ~/.wl-cache'"
echo "( journal | hive | catalog | core | cc | all | vim | scripts | wiki )"
echo ""
echo "spath: ${spath}"
# echo "verbose: ${verbose}"
echo "by - ${orderby}"
echo "dtype: ${dtype}"
echo "range:days - ${rangeDays}"
echo "term - ${searchTerm}"
echo "list:files - ${listFiles}"
fi

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
  cmd="-H $spath -lname '.*' ! -path '*/.*/*' -mtime -$rangeDays"
  # searchResults=$(find -H $spath -name '.*' ! -path '*/.*/*' -type f -mtime -$rangeDays)
else
  cmd="-H $spath ! -lname '.*' ! -path '*/.*' -mtime -$rangeDays"
  # searchResults=$(find -H $spath ! -name '.*' ! -path '*/.*' -type f -mtime -$rangeDays)
fi

if [ "$listFiles" == "0" ]; then
  echo "cmd: ${cmd}"
  echo -e "===============\n"

  searchResults=$(eval "find $cmd")

  #find -H $spath ! -name '.*' -maxdepth 5 -type f -mtime -1 $filenameFilter
  #for file in $(find -H $spath ! -name '.*' -type f -mtime -1 -exec basename {} \; | sort ); do
  res01=$(for file in $searchResults; do
    details=$(stat -f'%Sm' -t '%Y-%m-%dT%H%M' $file)
    echo $(lineFormat $file $details)
  done | sort)

  for file in $res01; do
    echo $file | sed 's/\(-[0-9]\{2\}\)T\([0-9]\{2\}\)\([0-9]\{2\}\)/\1 \2:\3 /g'
  done | column -t -s',' > ~/.wl-cache

  cat ~/.wl-cache | grep "$searchTerm"
  echo ""

elif [ "$cmdXargs" == "0" ]; then
  searchResults=$(eval "find $cmd")
  echo "$searchResults"

else
  searchResults=$(eval "find $cmd | xargs")
  echo "$searchResults"
fi


# ls -${ls_options} $spath | grep -v '.sw' | grep -v '^d' | tail -n10
