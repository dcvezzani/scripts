#!/bin/bash

function compareFiles() {
local expected="$1"
local actual="$2"
  
if [[ $expected == 'clean' ]]; then

  if [[ ! -e ./asdf.json ]]; then
cat << EOL
File does not exist; no cleanup necessary
EOL
    return 1
  fi

  git rm asdf.json -f
cat << EOL
Comparison file was successfully removed
EOL
  return 0
fi

# create "actual" file name from expected if no explicit "actual" file name was provided
if [[ -z $actual ]]; then
  actual=$(echo "$expected" | perl -p -e 's/(.*)(\..*)$/$1-actual$2/')
fi

if [[ -z $expected ]] || [[ -z $actual ]]; then
cat << EOL
Usage: ./scripts/compare-files.sh <expected> <actual>
EOL
  return 1
fi

cp "$expected" asdf.json; git add asdf.json
cp "$actual" asdf.json; git diff asdf.json
}

compareFiles $@
