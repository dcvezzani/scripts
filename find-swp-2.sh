#!/bin/bash

cnt=1
function search() {

# for dir in /Users/dcvezzani/scripts /Users/dcvezzani/vim-config /Users/dcvezzani/projects/church-history-adviser-cms /Users/dcvezzani/projects/church-history-adviser-ws /Users/dcvezzani/projects/church-history-specialist-fe /Users/dcvezzani/projects/deseret-industries-fe /Users/dcvezzani/projects/latter-day-saint-charities /Users/dcvezzani/projects/missionary-planning-cms /Users/dcvezzani/projects/missionary-planning-fe /Users/dcvezzani/projects/missionary-planning-ws /Users/dcvezzani/projects/missionary-referral-cms /Users/dcvezzani/projects/missionary-referral-fe /Users/dcvezzani/projects/missionary-referral-ws /Users/dcvezzani/projects/providentliving-cms /Users/dcvezzani/projects/records-keeping-cms /Users/dcvezzani/projects/records-keeping-fe /Users/dcvezzani/projects/recovery-cms /Users/dcvezzani/projects/recovery-fe /Users/dcvezzani/projects/recovery-ws /Users/dcvezzani/projects/self-service-fe /Users/dcvezzani/projects/seminary-and-institute-cms /Users/dcvezzani/projects/seminary-and-institute-fe /Users/dcvezzani/projects/seminary-and-institute-ws /Users/dcvezzani/projects/team-standup-fe /Users/dcvezzani/projects/team-standup-ws /Users/dcvezzani/projects/temples-cms /Users/dcvezzani/projects/temples-fe /Users/dcvezzani/projects/temples-ws /Users/dcvezzani/projects/thrasher-cms /Users/dcvezzani/projects/thrasher-fe /Users/dcvezzani/projects/thrasher-ws /Users/dcvezzani/projects/welfare-cms /Users/dcvezzani/Dropbox/journal/current; do

for dir in $(find /Users/dcvezzani/projects -maxdepth 1 -type d -mtime -4d); do
  local lines=$(find "$dir" -type f -mtime -4d \( -name '.*.sw*' -o -name '.sw*' \))
  echo "=== $cnt" 1>&2
  echo "$lines" 1>&2
  echo "$lines"

  cnt=$((cnt+1))
done
}

function search2() {
  local lines=$(find /Users/dcvezzani -maxdepth 1 -type f -mtime -4d \( -name '.*.sw*' -o -name '.sw*' \))
  echo "$lines" 1>&2
  echo "$lines"
}

cat << EOL | xargs ls -latr
$(search2)
$(search)
EOL
