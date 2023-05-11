#!/bin/bash

commit="$1"

function run() {
if [[ -z $commit ]]; then
cat << EOL
Usage: ~/scripts/git-files-in-commit.sh <commit>
E.g.:
~/scripts/git-files-in-commit.sh e80c640baf5ba21068abd20409dbcd1401d6d57b
EOL
return
fi

git diff-tree --no-commit-id --name-only $commit -r
}

run
