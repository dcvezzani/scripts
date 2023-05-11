#!/bin/bash

source ~/scripts/bash-colors.sh

cat << EOL
This script will replace all deprecated registry entries with 'icsrepo.churchofjesuschrist.org...'
EOL

read -p "$(blue 'Hit any key') to continue (Ctrl-c to quit)" ans

perl -pi -e 's#icsnpm.ldschurch.org/#icsrepo.churchofjesuschrist.org/artifactory/api/npm/npm-ics/#g; s#code.ldschurch.org/#icsrepo.churchofjesuschrist.org/#g' ./package-lock.json

cat << EOL
$(green 'Success: ') ./package-lock.json should have been updated
EOL

