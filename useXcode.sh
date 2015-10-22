#!/bin/zsh

if [ -z "$1" ]; then
  version=$(ls -lat /Applications | grep "Xcode \->" | sed 's/.*\/Applications\/Xcode\([^\/]*\).*/\1/')

  if [ -z "$version" ]; then
    echo "Current version unknown; no symbolic link is set up."

    appfile=$(ls -lat /Applications | grep " Xcode.app")
    if [ -z "$appfile" ]; then
    else
      echo "First create folders for different versions of Xcode "
      echo "and populate with the appropriate Xcode.app.  Then "
      echo "run this script again."
    fi

  else
    echo "Currently using Xcode${version}"
  fi

  echo "If desired, specify version of Xcode to activate (6.4, 7.0)"
  exit 0;
else
  if [ "$1" = '6.4' ] || [ "$1" = '7.0' ]; then
  else
    echo "Specify version of Xcode to activate (6.4, 7.0)"
    exit 1;
  fi
fi

appfile=$(ls -lat /Applications | grep " Xcode.app")
if [ -z "$appfile" ]; then
  sudo xcode-select --switch /Applications/Xcode${1}/Xcode.app

  if [ -h /Applications/Xcode ]; then
    sudo rm /Applications/Xcode
  fi

  sudo ln -s /Applications/Xcode${1}/Xcode.app /Applications/Xcode
  echo "Successfully activated Xcode${1}"

else
  echo "Unable to activate Xcode${1}; no action taken."
fi

