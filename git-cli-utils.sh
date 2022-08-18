#!/bin/bash

function show_usage() {
  echo 'Usage: ~/scripts/git-cli-utils.sh files [pretty|ls|git-add] [a|all|m|modified|c|conflict|s|staged|u|untracked|t|targeted]'
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

  git-add)
    resolvedCmd='git add'
    ;;
esac

# token='^ *[M\?]+'
case "$context" in
  m | modified)
    token='^( M)'
    ;;

  s | staged)
    token='^(M|A)'
    ;;

  c | conflict)
    token='^(UU)'
    ;;

  u | untracked)
    token='^(\?\?)'
    ;;

  t | targeted)
    token='targeted'
    ;;

esac
shift

pattern=${@:1:1}
patternsLength=$#

# cat << EOL
# util: $util
# action: $action
# context: $context
# resolvedCmd: $resolvedCmd
# token: $token
# pattern: $pattern
# patternsLength: $patternsLength
# EOL

# git st | grep modified | perl -p -e 's/^[ 	]+(modified): +(.*)/\1/g'

if [ "$token" = "targeted" ]; then
cmd_1=$(cat << EOL
ls $@
EOL
)
  
else
if [[ $patternsLength > 0 ]]; then
  additionalTokens="| grep \"$pattern\""
fi

cmd_1=$(cat << EOL
git status --porcelain --untracked-files=normal | perl -ne 'print if s/${token}[ 	]+(.*)/\2/' ${additionalTokens}
EOL
)
  
# echo "CMD: $cmd_1"

if [ "$action" = "ls" ]; then
  (eval "$cmd_1")
  exit 0
fi

fi

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

