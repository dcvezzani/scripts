#!/bin/bash

# commit
commit="$1"
if [ "$commit" == "" ]; then
# read -p "Paste the commit (e.g., 'ede3fb5..b18d894'): " commit
commit=$(git log | head -1 | awk '{print $2}')
fi

targetCommit=$(echo "$commit" | perl -p -e 's/[^0-9a-f]+/ /' | awk '{print $2}')

if [ "$targetCommit" == "" ]; then
targetCommit=$(echo "$commit" | perl -p -e 's/[^0-9a-f]+/ /' | awk '{print $1}')
fi

# userCapturedCommit='ede3fb5..b18d894  ARPWEB-77/display-all-meeting-types -> ARPWEB-77/display-all-meeting-types'
# commit=$(echo "$userCapturedCommit" | awk '{print $1}')

# branch: 
branch=$(git branch | grep -E '^\*' | awk '{print $2}')
# branch=$(echo "$userCapturedCommit" | awk '{print $2}')

# pr:
repo=$(git config --get remote.origin.url | perl -p -e 's/.*\/([^\.]+)\.git$/\1/')
repoLink=$(git config --get remote.origin.url | perl -p -e 's/([^:]+:\/\/)([^@]+@)(.*)\.git$/${1}${3}/')
commitLink="${repoLink}/commit/${commit}"
branchLink="${repoLink}/tree/${branch}"
pr=$(git ls-remote origin 'pull/*/head' | grep "$targetCommit" | awk '{print $2}' | perl -p -e 's/refs\/pull\/([^\/]+).*/https:\/\/github.com\/ICSEng\/'"$repo"'\/pull\/\1/')

# tag:
tag=$(git describe --abbrev=0 --tags)

# - commit: <a href="$commitLink">$commit</a>
# - branch: <a href="$branchLink">$branch</a>

output=$(cat << EOL
$repo
- commit: $commit
- branch: $branch
- most recent tag: $tag
EOL

if [ ! "$pr" = "" ]; then
echo "- pr: $pr"
fi
)
echo "$output" | pbcopy

cat << EOL

Copied to clipboard:

$output
EOL

