#!/bin/bash

# ============================ #
function run_cmd() {
  local cmd="$1"
  if [[ $DEBUG == 'true' ]]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
}

# ============================ #
function prepare_args() {
local project="$1"
local zipFilePath="$2"
local baseDir='~/projects/team-one-project-dev-notes'
local projects='admin arp cstemple di misrf si'

if [[ -z $zipFilePath ]]; then
cat << EOL >&2
Usage: view_documentation <project> <zipFilePath>
EOL
  echo -n "{\"baseDir\":\"${baseDir}\"}"
  return
fi

local dirName=$(basename "$zipFilePath" | perl -p -e 's/\.zip$//')

echo -n "{\"project\":\"${project}\",\"zipFilePath\":\"${zipFilePath}\",\"dirName\":\"${dirName}\",\"baseDir\":\"${baseDir}\"}"
}

# ============================ #
function parse_json_arg() {
  local jsonArgs="$1"
  local name="$2"

  jq -n "$jsonArgs" | jq -r ".${name}"
}

# ============================ #
function list_projects() {
local jsonArgs=$(prepare_args "$1" "$2")
local baseDir=$(parse_json_arg "$jsonArgs" "baseDir")

local CMD=$(cat << EOL
cd $baseDir
find . -type d -maxdepth 1 | perl -p -e 's/\.\///' | grep -vE '\.git|\.'
EOL
)
run_cmd "$CMD"
}


# ============================ #
function stage_documentation() {
local jsonArgs=$(prepare_args "$1" "$2")
local project=$(parse_json_arg "$jsonArgs" "project")
local zipFilePath=$(parse_json_arg "$jsonArgs" "zipFilePath")
local dirName=$(parse_json_arg "$jsonArgs" "dirName")
local baseDir=$(parse_json_arg "$jsonArgs" "baseDir")

local CMD=$(cat << EOL
mkdir -p ${baseDir}/${project}/${dirName}
cd ${baseDir}/${project}/${dirName}
unzip $zipFilePath
EOL
)

run_cmd "$CMD"
}

# ============================ #
function commit_documentation() {
local jsonArgs=$(prepare_args "$1" "$2")
local project=$(parse_json_arg "$jsonArgs" "project")
local zipFilePath=$(parse_json_arg "$jsonArgs" "zipFilePath")
local dirName=$(parse_json_arg "$jsonArgs" "dirName")
local baseDir=$(parse_json_arg "$jsonArgs" "baseDir")

local CMD=$(cat << EOL
cd $baseDir
git add .
git commit
local rstatus=\$?

echo -n "\$rstatus" >&2
if [[ \$rstatus == 0 ]]; then
git push origin main
fi
EOL
)

run_cmd "$CMD"
}

# ============================ #
function view_documentation() {
local jsonArgs=$(prepare_args "$1" "$2")
local project=$(parse_json_arg "$jsonArgs" "project")
local zipFilePath=$(parse_json_arg "$jsonArgs" "zipFilePath")
local dirName=$(parse_json_arg "$jsonArgs" "dirName")

local CMD=$(cat << EOL
open https://github.com/ICSEng/team-one-project-dev-notes/tree/main/$project/$dirName/$dirName
EOL
)

run_cmd "$CMD"
}


# ============================ #
function publish_documentation() {
stage_documentation "$1" "$2"
commit_documentation "$1" "$2"
view_documentation "$1" "$2"
}

if [[ -z $2 ]]; then
cat << EOL
Usage: ~/scripts/team-one-project-dev-notes/publish-zip.sh <project> <zipFilePath>

DEBUG=true 
stage_documentation   <project>  <zipFilePath>
commit_documentation  <project>  <zipFilePath>
view_documentation    <project>  <zipFilePath>

Available projects
$(list_projects | xargs)

E.g., 
~/scripts/team-one-project-dev-notes/publish-zip.sh misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip

stage_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
commit_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
view_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
EOL
else
publish_documentation "$1" "$2"
fi

# DEBUG=true 
# stage_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
# commit_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
# view_documentation misrf /Users/dcvezzani/Downloads/20230825-misrf-316-misrf-327-misrf-317-feed.md.zip
