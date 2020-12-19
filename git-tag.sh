#/bin/bash

usage="Usage:
- ./git-tag.sh 1.8.1 1.8.5
- ./git-tag.sh 1.8.1 1.8.5 pom.xml

"

fromVersion="$1"
version="$2"
filename=pom.xml

if [ "$1" == "" ] || [ "$2" == "" ]; then
  echo "$usage"
  exit 1
fi

if [ "$3" == "" ]; then
filename="$3"
fi

perl -pi -e 's#^    <version>'"$fromVersion"'<#    <version>'"$version"'<#g' "$filename"
git add pom.xml
git commit -m "Version ${version}"
git tag -a "v${version}" -m "Version ${version}"
git push origin dev --tags

