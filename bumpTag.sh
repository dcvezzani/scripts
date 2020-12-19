#/bin/bash

if [ "$1" == "" ]; then
  echo "Usage: ~/scripts/bumpTag.sh '1.8.1'"
  exit 1
fi

if [ "$2" == "-f" ]; then
  force=true
fi

# version=1.8.1
version="$1"
git commit -m "Version ${version}"

if [ "$force" == "true" ]; then
  git tag -d "v${version}"
fi

git tag -a "v${version}" -m "Version ${version}"

if [ ! "$?" == "0" ]; then
  echo "Unable to create tag (locally)"
  exit 1
fi

git push origin dev --tags

if [ ! "$?" == "0" ]; then
  echo "Unable apply tags (remotely)"
  exit 1
fi

