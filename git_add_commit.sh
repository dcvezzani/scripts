#!/bin/bash

function  git_add_commit() {
local files=$@
local message=$(cat < /dev/stdin)

git add $@
git commit -m "$message"
}

cat << EOL2
==========================================
git_add_commit has been loaded!

--- to load ---------------------------------------
Usage: 
source ~/scripts/git_add_commit.sh

--- to use ----------------------------------------
Usage: 
<message content> | git_add_commit <file> <file> ... <file>

E.g., 
cat << EOL | git_add_commit test/data/lib/contracts/unit_test/ws-temples-details-contract.json test/data/local/blt-temple-details.json test/data/local/pubhub.json
update expected test payload

fix tests
- with the food services drawer logic fixed, the correct results should now be coming through
- if the expected tisds property does not exist in the tisds /details payload, the drawer should not be rendered at all

cms /details form update
- with recent updates to the cms tier to remove icon strings, it is possible to receive a cms service response payload without them (if the /details document has been saved after the schema change).  It is also possible the icon strings will still come through for cases where the /details document has not been updated/saved since the schema change
EOL
EOL2
