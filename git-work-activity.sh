#!/bin/bash

target_date="$1"
target_next_date="$2"
for_week=""
for_author=""
MY_AUTHOR_VALUE="David Vezzani <dcvezzani@churchofjesuschrist.org>"

if [[ $FOR_WEEK == 'true' ]] || [[ $target_date == 'last-week' ]]; then
  for_week='true'
fi

if [[ ! -z $FOR_AUTHOR ]]; then
  for_author='$FOR_AUTHOR'
fi

if [[ -z $for_author ]] && [[ $FOR_ME == "true" ]]; then
  for_author="$MY_AUTHOR_VALUE"
fi

if ( [[ -z $target_date ]] || [[ $target_date == 'today' ]] ); then
  target_date=$(date '+%Y-%m-%d')
fi

if [[ $target_date == 'yesterday' ]]; then
  target_date=$(date -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'tomorrow' ]]; then
  target_date=$(date -v +1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'last-friday' ]]; then
  target_date=$(date -v -Fri -v -0d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'last-week' ]]; then
  target_date=$(date -v -7d -v -Mon -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'week-of' ]]; then
  week_of_date="$2"
  for_week='true'
  target_date=$(date -v -Mon -v -0d -jf '%Y-%m-%d' "$week_of_date" "+%Y-%m-%d")
  target_next_date=$(date -v +7d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
fi

if [[ -z $target_next_date ]]; then
  # target_next_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
  target_next_date="$target_date"
fi

function projForRepo() {
repo="$1"

  if [[ "${repo}" =~ recovery ]]; then
    proj=ARPWEB

  elif ( [[ "${repo}" =~ church-history-adviser ]] || [[ "${repo}" =~ church-history-specialist ]] ); then
    proj=CHADV

  elif [[ "${repo}" =~ records ]]; then
    proj=CHREC

  elif [[ "${repo}" =~ temples ]]; then
    proj=CSTEMPLE

  elif [[ "${repo}" =~ self-service ]]; then
    proj=DTRUST

  elif [[ "${repo}" =~ charities ]]; then
    proj=LDSC

  elif [[ "${repo}" =~ missionary-planning ]]; then
    proj=MISN

  elif [[ "${repo}" =~ missionary-referral ]]; then
    proj=MISRF

  elif [[ "${repo}" =~ seminary-and-institute ]]; then
    proj=SI

  elif [[ "${repo}" =~ thrasher ]]; then
    proj=THRASH

  elif ( [[ "${repo}" =~ deseret-industries-fe ]] || [[ "${repo}" =~ welfare-cms ]] ); then
    proj=WFRPUB_DI

  elif [[ "${repo}" =~ providentliving-cms ]]; then
    proj=WFRPUB_PL

  elif [[ "${repo}" =~ brightspot ]]; then
    proj=BSPWEB

  else
    proj=ADMIN
  fi

echo "$proj"
}

function workDatesForWeekOfTargetDate() {

local target_date="$1"
local target_date=$(date -v -Mon -v +0d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
echo "$target_date"
for i in {1..4}; do
local target_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
echo "$target_date"
done

# target_date=$(date -v -Mon -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
# target_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
# echo "$target_date"
# target_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
# echo "$target_date"

}

function gitActivityForTargetDate() {

local target_date="$1"
local target_next_date="$2"

if [[ -z $target_next_date ]]; then
  # target_next_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
  local target_next_date="$target_date"
fi

cat << EOL | perl -p -e 's/^\.$//'
.
target_date: $target_date
-----------------------------------
EOL

for repo in $(~/scripts/ls-projects.sh); do
local proj=$(projForRepo "$repo")

# echo "Processing ${repo} (${proj})..." 1>&2
cd "$repo"

if [[ -d .git ]]; then
# CMD=$(cat << EOL
# git log --oneline --since="${target_date}" --until="${target_next_date}" | less -F
# EOL
# )

# echo "$CMD"

  git log --pretty=format:"- ${proj} ç %C(yellow)${repo##*/}%Creset ç %h ç %an ç %s" --author="$for_author" --since="${target_date}T00:00:00" --until="${target_next_date}T23:59:59" \
| while read -r line; do truncated_message=$(echo "$line" | awk '{print substr($0, 1, 2048)}'); echo "$truncated_message"; done 

# while read line; do
#   echo "- ${proj} ç ${repo##*/} ç ${line}"
# done < <(git log --pretty=format:"%h ç %an ç %s" --author="$for_author" --since="${target_date}T00:00:00" --until="${target_next_date}T23:59:59" \
# | while read -r line; do truncated_message=$(echo "$line" | awk '{print substr($0, 1, 2048)}'); echo "$truncated_message"; done \
# | less -F)

fi
  
done | grep -E '^- ' | perl -p -e 's/^- //' | column -t -s 'ç'

}

if [[ -z $for_week ]]; then
  gitActivityForTargetDate "$target_date"
else
  for t_date in $(workDatesForWeekOfTargetDate "$target_date"); do
    gitActivityForTargetDate "$t_date"
  done
fi


