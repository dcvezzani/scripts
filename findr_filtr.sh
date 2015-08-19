
alias glnum="awk -F: '{print \$1\":\"\$2}'"
alias gsimp="grep -v spec | grep -v features | grep -v oneoff"

function filtr () {
  post_opts=""
  grep_opts="-r"
  debugging=0

  if [ ! -z "$3" ]; then
    if [[ "$3" == "no-recursion" ]]; then 
      grep_opts="-"
    fi
  fi

  if [ ! -z "$2" ]; then
    if [[ "$2" =~ "n" ]]; then 
      post_opts="$post_opts | glnum"
    fi
    if [[ "$2" =~ "f" ]]; then 
      post_opts="$post_opts | gsimp"
    fi
    if [[ "$2" =~ "l" ]]; then 
      grep_opts="${grep_opts}l"
    else
      grep_opts="${grep_opts}n"
    fi
    if [[ "$2" =~ "d" ]]; then 
      debugging=1
    fi
  fi

  cmd="xargs grep ${grep_opts} \"$1\" ${post_opts}"

  if [[ $debugging -eq 1 ]]; then
    echo "call command: $cmd"
  fi

  eval $cmd
}

function filtr_dir () {
for FILE in `ls -l`
do
    if test -d $FILE
    then
      echo $FILE
    fi
done
}

# find ruby files that contain a given term; print lines with line numbers
function findr () {
  verbose=0
  debugging=0
  help=0
  find_pattern="-name \"*.rb\""

  if [ -z "$1" ]; then
    help=1
  else
    if [[ "$1" == "h" ]]; then
      help=1
    fi
  fi

  if [[ $help -eq 1 ]]; then
    echo "
========================================================================
FINDR, FILTR
========================================================================

Find ruby files.

Quick examples:

findr <term>
findr RetryStuckOrders
findr RetryStuckOrders fn
findr RetryStuckOrders fl
findr TrackingNumber fl | filtr Job fl


Show how to use findr and filtr to locate search hits in ruby files.

- h:      this help msg     findr only

findr h


For debugging purposes
- v:      verbose           findr only
- d:      debug             findr and filtr

findr RetryStuckOrders v
findr RetryStuckOrders d
findr RetryStuckOrders dv


Options for both findr and filtr:

'l' and 'n' options cannot be used at the same time; 'l' will trump
- f:      filter out 'spec' and 'oneoff' related files
- n:      include line numbers (passed off to 'grep -rn')
- l:      list the files, unadorned; can be used with xargs to do further 
          processing (passed off to 'grep -rl')

findr RetryStuckOrders f
findr RetryStuckOrders n
findr RetryStuckOrders l
findr RetryStuckOrders fn
findr RetryStuckOrders fl


Can be used with filtr to further process; should include 'l' option if 
searching in files as opposed to filtering through filenames and/or 
displayed lines.

findr TrackingNumber fl | wc                     # 14 lines
findr TrackingNumber fl | filtr Job fl | wc      #  7 lines


One can chain with filtr as much as desired.  Again, if you are searching *in* 
files, you will want to include the 'l' for each chain; the last chain is, of 
course, optional.

findr TrackingNumber fl|filtr Job fl | filtr Turbo f


One can also integrate with other command line functions/commands.

findr TrackingNumber fl|filtr Job f | grep Turbo
findr TrackingNumber fl|filtr Job f | grep Ebay
findr TrackingNumber fl|filtr Job f | grep \"Ebay\\|Turbo\"

" | less
  else
    if [ ! -z "$2" ]; then
      if [[ "$2" =~ "v" ]]; then 
        #echo "found v"
        verbose=1
      fi
      if [[ "$2" =~ "d" ]]; then 
        debugging=1
      fi
    fi
    #echo ">> $verbose, $2"
    
    if [[ "$2" =~ "r|m" ]]; then
      find_pattern="-name \"xxxx\""

      if [[ "$2" =~ "r" ]]; then
        find_pattern="$find_pattern -o -name \"*.rb\""
      fi
      if [[ "$2" =~ "m" ]]; then
        find_pattern="$find_pattern -o -name \"*.erb\" -o -name \"*.haml\""
      fi
    else
      if [[ "$2" =~ "a" ]]; then
        # find_pattern="-name \"*.git*\" ! -name \"*.log\""
        find_pattern="! -path \"*\\.git*\" ! -path \"*log*\""
      else
        find_pattern="-name \"*.rb\""
      fi
    fi

    cmd="find . $find_pattern | filtr $1 $2"
    
    if [[ $verbose -eq 0 ]]; then 
      #echo "be quiet"
      cmd="exec 3>&2; exec 2> /dev/null; $cmd; exec 2>&3"
    fi
    
    if [[ $debugging -eq 1 ]]; then
      echo "call command: $cmd"
    fi
    
    eval $cmd

  fi
}


