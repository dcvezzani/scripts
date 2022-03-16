#!/bin/bash

function show_usage() {
  echo 'Usage: ~/scripts/git-cli-utils.sh files (a|all|m|modified|s|staged) yarn pretty-file'
  exit 1
}

util="$1"
if [ "$util" == "" ]; then
  show_usage
fi

shift

# action
action="$1"
if [ "$action" == "" ]; then
  show_usage
fi

shift

context="$1"
if [ "$context" == "" ]; then
  show_usage
fi

resolvedCmd="$action"
case "$action" in
  pretty)
    resolvedCmd='prettier --config ~/.prettierrc-global --write'
    ;;

  ls)
    resolvedCmd='ls'
    ;;
esac

token=' *M'
case "$context" in
  m | modified)
    token='^ M'
    ;;

  s | staged)
    token='^M'
    ;;
esac

# git st | grep modified | perl -p -e 's/^[ 	]+(modified): +(.*)/\1/g'

cmd_1=$(cat << EOL
git status --porcelain --untracked-files=all | perl -ne 'print if s/${token}[ 	]+(.)/\1/' 
EOL
)
# echo "CMD: $cmd_1"
payload=$(eval "$cmd_1")

cat << EOL

Action '$action' will be performed on the following files

$payload

EOL

# payload=$(cat << EOL
# 	modified:   devops/terraform/lambda/duplicate-meeting-instances-cleanup/code/app.js
# 	modified:   src/cldr/timezone.js
# 	modified:   src/templates/home/home.json
# 	modified:   src/templates/home/index.js
# EOL
# )

cmd_2=$(cat << EOL
$cmd_1 | xargs $resolvedCmd
EOL
)
echo "CMD: $cmd_2"
eval "$cmd_2"

echo "DONE"

