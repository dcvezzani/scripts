#!/bin/bash

DEFAULT_PR_REVIEWERS='adamandreason,jtthor,tberbert'

# === current_branch =========================

function current_branch(){
  # git branch | grep -E '^\*' | awk '{print $2}'
  git branch --show-current
}

# === join_by =========================
function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

# === jira_card_id =========================

function jira_card_id(){
  usage=$(cat << EOL
Usage: jira_card_id srcBranch 
EOL
)
  
  local srcBranch="$1"
  if [[ "$srcBranch" == "" ]]; then srcBranch=$(current_branch); fi

  if [ "$srcBranch" = "" ]; then echo "$usage" 1>&2; return; fi

  node -e 'const jiraCardId=(process.argv[1]?.split(/\//) || []).find(entry => entry != "dcv"); console.log(jiraCardId)' -- $(echo "$srcBranch")
  # awk '{split($0, array, "\/"); print array[2]}' <<< "$srcBranch"
}

function dryrun_or_run() {

  local cmds=()
  if [ -p /dev/stdin ]; then
    while IFS= read cmd; do
      # echo "Adding command: ${cmd}"
      cmds+=("$cmd")
    done
  else
    cmds+=("$1")
  fi
  
  usage=$(cat << EOL
Usage: dryrun_or_run "$cmd"
Usage: DRYRUN=y dryrun_or_run "$cmd"
EOL
)

  local cmd="${cmds[2]}"
  # ${#array_name[@]}; length of array
  
  if [[ "$cmd" == "" ]]; then echo "$usage" 1>&2; return; fi
  
  if [[ ! "$DRYRUN" == "y" ]]; then
    echo -e $(join_by "\n\n" "${cmds[@]}") 1>&2
    eval "$cmd"
  else
    echo -e "\nDRYRUN: Commands (${#cmds[@]}): \n" 1>&2
    for i in {1..${#cmds[@]}}; do
      echo -e "${cmds[i]}\n" | perl -pe 's/&quot;/\\"/g; s/&newline;/\n/g' 1>&2
    done
    
  fi
};

# === repo_name =========================

function repo_name() {
  printf $(awk '{split($0, array, "\/"); print array[5]}' <<< $(git config --get remote.origin.url)) | perl -p -e 's/\..*$//'
}

# === repo_name =========================

function tier_type() {
  repo_name | perl -pe 's/.*-([^-]+)$/$1/' | perl -lne 'print uc($_);'
}

# === create_pr =========================

function create_pr(){

if [ -p /dev/stdin ]; then
  local description="$(cat | perl -pe 's/"/&quot;/g; s/[\n\r]+/&newline;/g')"
else
  local description="$2"
fi

  usage=$(cat << EOL2
Usage: 

create_pr "fixes bug"

create_pr "fixes bug" "this is a description for the pr"

# multiple line support for description
cat << EOL | create_pr "fixes bug"
bug fix includes the following
- one
- two
- three
- gets the "work" done
EOL

DRYRUN=y REVIEWERS=tberbert JIRA_CARD_ID=2345 SRC_BRANCH="dcv/2345/feature-branch" DST_BRANCH="dcv/feature-branch" DRYRUN=y create_pr "fixes bug" "this is a description for the pr"

DRYRUN=y REVIEWERS=tberbert JIRA_CARD_ID=2345 SRC_BRANCH="dcv/2345/feature-branch" DST_BRANCH="dcv/feature-branch" DRYRUN=y SIMPLE_TITLE=y create_pr "fixes bug" "this is a description for the pr"
EOL2
)
  
  if ( [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] ); then
    echo "$usage" 1>&2
    return
  fi

  local srcBranch="$SRC_BRANCH"
  if [[ "$srcBranch" == "" ]]; then srcBranch=$(current_branch); fi
  
  local jiraCardId="$JIRA_CARD_ID"
  if [[ -z "$jiraCardId" ]]; then 
    local jiraCardId=$(jira_card_id "$srcBranch")
  fi
  
  if [[ "$SIMPLE_TITLE" == 'y' ]]; then 
    local title="$1"
  else
    local title="${jiraCardId} ($(tier_type)) - $1"
  fi

  local dstBranch="$DST_BRANCH"
  if [[ "$dstBranch" == "" ]]; then dstBranch='dev'; fi
  

  # if [ "$title" = "" ]; then echo "$usage" 1>&2; return; fi
  if [[ "$title" == "" ]]; then
    local title=$(git show -s --format='%s')
  fi

  local reviewers="$REVIEWERS"
  if [ "$reviewers" = "" ]; then 
    local reviewers="$DEFAULT_PR_REVIEWERS"
  fi
  
cat << EOL | dryrun_or_run
DRYRUN="$DRYRUN" JIRA_CARD_ID="$jiraCardId" SRC_BRANCH="$srcBranch" DST_BRANCH="$dstBranch" create_pr "$title" "$description"
gh pr create --base "$dstBranch" --head "$srcBranch" --title "$title" --body "$description" --reviewer "$reviewers"
EOL

  # if ( [[ $DRYRUN == 'y' ]] ); then 
  #   echo "Running in DRYRUN mode..."
  # else
  #   eval "$cmd"
  # fi

  # dryrun_or_run "$cmd" "$dryrun"
};

# === clear_github_token =========================

function clear_github_token(){
  usage=$(cat << EOL
Usage: clear_github_token; Description: clears cached github PAT token; this is typically required when the PAT token expires
EOL
)

if [[ ! -z "$HELP" ]]; then
  echo -e "$usage"
  return
fi

  cmd=$(cat << EOL
rm ~/.config/hub
EOL
)

unset ans
(cat << EOL
CMD:
$cmd

Confirm action (Ctrl-c to cancel)
EOL
)
read ans

eval "$cmd"
  # dryrun_or_run "$cmd" "$dryrun"
};

create_pr --help

(cat << EOL
Other functions:

$(HELP=y clear_github_token)
EOL
)


# ARCHIVE

# if [ ! "$1" = "" ]; then
#   create_pr "$1" "$2"
# else
#   echo "Successfully loaded git pr utilities"
#   echo

#   create_pr
# fi

# === create_pr =========================

# function create_pr_v1(){
#   usage=$(cat << EOL
# Usage: 

# create_pr_v1 dstBranch "fixes bug"

# create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"

# DRYRUN=y create_pr_v1 dstBranch "fixes bug"

# DRYRUN=y create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"

# DRYRUN=y create_pr_v1 dstBranch "fixes bug" "\$(cat << EOL\nthis is a description for the pr\nthat consists of multiple lines\nEOL\n)"

# DRYRUN=y REVIEWERS=tberbert JIRA_CARD_ID=2345 SRC_BRANCH="dcv/2345/feature-branch" create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"
# EOL
# )
  
#   local dstBranch="$1"
#   local title="$2"
#   local description="$3"

#   if [ "$dstBranch" = "" ]; then echo "$usage" 1>&2; return; fi
#   if [ "$title" = "" ]; then echo "$usage" 1>&2; return; fi
  
#   local srcBranch="$SRC_BRANCH"
#   local jiraCardId="$JIRA_CARD_ID"
#   local reviewers="$REVIEWERS"
#   local dryrun="$DRYRUN"

#   if [ "$srcBranch" = "" ]; then 
#     local srcBranch=$(current_branch)
#   fi

#   if [ "$jiraCardId" = "" ]; then 
#     local jiraCardId=$(jira_card_id "$srcBranch")
#   fi

#   if [ "$reviewers" = "" ]; then 
#     local reviewers="$DEFAULT_PR_REVIEWERS"
#   fi

#   if ( [ "$dryrun" = "dryrun" ] || [ "$dryrun" = "y" ] ); then 
#     local dryrun="dryrun"
#     echo "Running in DRYRUN mode..."
#   fi
  
#   cmdParts=()
#   cmdParts+=$(cat << EOL
# # hub pull-request -b "$dstBranch" -h "$srcBranch" -m "$jiraCardId $title" -m "$description" --reviewer "$reviewers"
# gh pr create --base "$dstBranch" --head "$srcBranch" --title "$jiraCardId $title" --body "$description" --reviewer "$reviewers"
# EOL
# )
  
#   cmd=$(printf '%s\n' "$(IFS=' '; printf '%s' "${cmdParts[*]}")")

#   dryrun_or_run "$cmd" "$dryrun"
# };


