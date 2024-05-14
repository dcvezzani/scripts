#!/bin/bash

target_date="$1"
target_next_date="$2"

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
  target_date=$(date -v -Sat -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ -z $target_next_date ]]; then
  target_next_date=$(date -v +1d -jf '%Y-%m-%d' "$target_date" "+%Y-%m-%d")
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

  else
    proj=ADMIN
  fi

echo "$proj"
}

for repo in $(~/scripts/ls-projects.sh); do
proj=$(projForRepo "$repo")
# echo "Processing ${repo} (${proj})..." 1>&2
cd "$repo"

# CMD=$(cat << EOL
# git log --oneline --since="${target_date}" --until="${target_next_date}" | less -F
# EOL
# )

# echo "$CMD"

while read line; do
  echo "- ${proj}; ${line}"
done < <(git log --oneline --since="${target_date}" --until="${target_next_date}" | less -F)
  
done | grep -E '^- ' | perl -p -e 's/^- //'
