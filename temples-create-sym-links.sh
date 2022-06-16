function remove_if_exists() {
  local filename=$1
  local dryrun=$2

  local usage="Usage: remove_if_exists ./node_modules/@churchofjesuschrist/idm-oauth [dryrun]"
  if [ "$filename" = "" ]; then echo "$usage"; (exit 1); return; fi

  if ( ! [ -L $filename ] && [ -e $filename ] ); then
    cmd="rm -r $filename"
    echo "About to '${cmd}'; are you sure? (Ctrl-c quit, Enter continue)"
    read ans

    if [ "$dryrun" = "dryrun" ]; then
      echo "Dryrun: $cmd"
    else
      eval "$cmd"
    fi

  else
    if ! [ -e $filename ]; then
      echo "Info: File does not exist"
    elif [ -L $filename ]; then
      echo "File is a symlink"
      (exit 11)
    fi
  fi
};

function try_link_resource() {
  local srcFilename=$1
  local dstFilename=$2
  local dryrun=$3

  local usage="Usage: try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth ./node_modules/@churchofjesuschrist [dryrun]"
  if [ "$srcFilename" = "" ]; then echo "$usage"; (exit 1); return; fi
  if [ "$dstFilename" = "" ]; then echo "$usage"; (exit 1); return; fi

  remove_if_exists $dstFilename $dryrun; returnCode="$?"

  cmd="ln -s $srcFilename $dstFilename"
  if [[ $returnCode -eq 0 ]]; then
    if [ "$dryrun" = "dryrun" ]; then
      echo "Dryrun: $cmd"
    else
      echo "Creating symlink"
      echo "$cmd"
      eval "$cmd"
    fi
  else
    echo "Unable to create symlink"
    echo "$cmd"
  fi
  echo
};

try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth ./node_modules/@churchofjesuschrist/idm-oauth
try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/team-one-logging ./node_modules/@churchofjesuschrist/team-one-logging
try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/team-one-logging /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/node_modules/@churchofjesuschrist/team-one-logging
try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/team-one-config ./node_modules/@churchofjesuschrist/team-one-config
try_link_resource /Users/dcvezzani/projects/@churchofjesuschrist/team-one-config /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/node_modules/@churchofjesuschrist/team-one-config

