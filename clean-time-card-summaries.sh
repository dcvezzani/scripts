#/bin/bash

if [ "$1" == "" ]; then
  echo "Usage: ~/scripts/clean-time-card-summaries.sh /Users/dcvezzani/Dropbox/journal/current/20190923-time-card-summaries.md"
fi

perl -pi -e 's/ - .*$//g; s/^\d.*	\[/\[/g' "$1"
perl -ni -e 'unless(/^https/){print, "\n"}' 

