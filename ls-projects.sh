#!/bin/bash

function join_array {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function ls_projects() {
local filter="$1"

if [[ ! -z "$HELP" ]]; then
cat << EOL
Usage: 
ls_projects                        # list all projects
ls_projects fe                     # list all fe (front end) projects 
ls_projects ws,fe,cms              # commas trigger creation of regular expression; transform to '(\-ws|\-fe|\-cms)$'
ls_projects 'seminary'             # use regular expression
EXPLICIT=y ls_projects 'blah,bleh' # use regular expression and honor comma (do not transform)
EOL
return
fi

local list=$(find -L ~/projects -type d -maxdepth 1 \( -name "*-fe" -o -name "*-cms" -o -name "*-ws" -o -name "latter-day-saint-charities" \) ! -name '*-web-ws' ! -name 'oauth*' ! -name 'ch-records*' ! -name 'church-history-adviser-fe' ! -name 'di-fe';
find -L ~/projects/@churchofjesuschrist -type d -maxdepth 1 \( -name "idm-oauth" -o -name "team-one-config" -o -name "team-one-logging" \)
) 

if [ ! "$filter" = "" ]; then
  local _filter="$filter"
  if [[ $filter =~ , ]] && [[ -z "$EXPLICIT" ]]; then
    if [[ ! -z $ZSH_VERSION ]]; then
      local filterArray=("${(ps:,:)$(echo "$filter")}") # split string on comma ','
    else
      IFS=',' read -r -a filterArray <<< "$filter"
    fi
    
    # local filterArray=("${filterArray[@]:0}")
    local _filter='(\-'$(join_array '|\-' $(echo "${filterArray[*]}"))')$' # join string on regexp using filter values
  fi

  (echo -e "$list" | grep -E "$_filter" | sort -u)
else
  (echo -e "$list" | sort -u)
fi
};

function ls_projects_search() {
local filter="$1"
local filepath="$2"
local filename="$3"
local term="$4"

if [ -z "$filepath" ] || [ -z "$filename" ] || [[ ! -z "$HELP" ]]; then
cat << EOL
Usage: ls_projects_search <filter> <target-filepath> <target-filename> <term-in-file>
- ls_projects_search '' '' 'pipelines.yml' 'none'
- ls_projects_search 'ws,fe' 'devops' 'pipelines.yml' 'none'
EOL
return
fi

local _filepath="$filepath"
if [[ $filepath =~ , ]] && [[ -z "$EXPLICIT" ]]; then
  if [[ ! -z $ZSH_VERSION ]]; then
    local filepathArray=("${(ps:,:)$(echo "$filepath")}") # split string on comma ','
  else
    IFS=',' read -r -a filepathArray <<< "$filepath"
  fi

  local _filepath=$(join_array '" -o -name "' $(echo "${filepathArray[*]}")) # join string on regexp using filter values
else
  local filepathArray=("$filepath")
fi

local _filename="$filename"
if [[ $filename =~ , ]] && [[ -z "$EXPLICIT" ]]; then
  if [[ ! -z $ZSH_VERSION ]]; then
    local filenameArray=("${(ps:,:)$(echo "$filename")}") # split string on comma ','
  else
    IFS=',' read -r -a filenameArray <<< "$filename"
  fi
else
  local filenameArray=("$filename")
fi

local grepTerm=""
if [[ ! -z $term ]]; then
local grepTerm=$(cat << EOL
 | grep -v 'find: ' | xargs grep -E "$term"
EOL
)
fi

# echo "_filepath: $_filepath"
# echo "filepathArray: $filepathArray"

if [[ ! -z $MAXDEPTH ]]; then
local maxdepth="-maxdepth ${MAXDEPTH} "
fi

local CMD=$(cat << EOL
for dir in $(ls_projects "$filter" | xargs); do
find -L "\${dir}/\$(join_array '" "\${dir}/' $(echo "${filepathArray[*]}"))" ${maxdepth}\( -name "$_filename" \) 2>1
done \
$grepTerm
EOL
)

if [[ ! -z $PREVIEW_PROMPT ]] && [[ "$PREVIEW_PROMPT" == "y" ]]; then
(echo -e "$CMD" )
unset ans; read ans
fi

(eval "$CMD")

};

if [[ ! -z "$LOADING" ]]; then
cat << EOL
ls-project functions have been loaded

$(HELP=y ls_projects)

$(HELP=y ls_projects_search)
EOL

else
ls_projects "$1"
fi

