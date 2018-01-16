#!/bin/bash

chk=$(git branch)
if [ $? -neq 0 ]; then
	echo "The current directory doesn't seem to have a git repo."
	exit
fi

git_remote=$(git config --get remote.origin.url)
github_url=$(echo "$git_remote" | sed 's#\.git$##g;s#^git\@#https://#g;s#^\([^:]*:[^:]*\):\(.*\)#\1/\2#g')
echo Copying "$github_url"
echo "$github_url" | pbcopy
open "$github_url"
