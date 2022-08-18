#!/bin/bash

DEFAULT_PR_REVIEWERS='adamandreason,jtthor,tberbert,skoeven'

# === current_branch =========================

function current_branch(){
  git branch | grep -E '^\*' | awk '{print $2}'
}

# === jira_card_id =========================

function jira_card_id(){
  usage=$(cat << EOL
Usage: jira_card_id srcBranch 
EOL
)
  
  local srcBranch="$1"

  if [ "$srcBranch" = "" ]; then echo "$usage" 1>&2; return; fi

  awk '{split($0, array, "\/"); print array[2]}' <<< "$srcBranch"
}

function dryrun_or_run() {
  usage=$(cat << EOL
Usage: dryrun_or_run "$cmd"
Usage: dryrun_or_run "$cmd" dryrun
EOL
)

  local cmd="$1"
  local dryrun="$2"

  if [ "$cmd" = "" ]; then echo "$usage" 1>&2; return; fi
  
  if [ ! "$dryrun" = "dryrun" ]; then
    echo -e "$cmd" 1>&2
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd" 1>&2
  fi
};

# === create_pr =========================

function create_pr_v1(){
  usage=$(cat << EOL
Usage: 

create_pr_v1 dstBranch "fixes bug"

create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"

DRYRUN=y create_pr_v1 dstBranch "fixes bug"

DRYRUN=y create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"

DRYRUN=y create_pr_v1 dstBranch "fixes bug" "\$(cat << EOL\nthis is a description for the pr\nthat consists of multiple lines\nEOL\n)"

DRYRUN=y REVIEWERS=tberbert JIRA_CARD_ID=2345 SRC_BRANCH="dcv/2345/feature-branch" create_pr_v1 dstBranch "fixes bug" "this is a description for the pr"
EOL
)
  
  local dstBranch="$1"
  local title="$2"
  local description="$3"

  if [ "$dstBranch" = "" ]; then echo "$usage" 1>&2; return; fi
  if [ "$title" = "" ]; then echo "$usage" 1>&2; return; fi
  
  local srcBranch="$SRC_BRANCH"
  local jiraCardId="$JIRA_CARD_ID"
  local reviewers="$REVIEWERS"
  local dryrun="$DRYRUN"

  if [ "$srcBranch" = "" ]; then 
    local srcBranch=$(current_branch)
  fi

  if [ "$jiraCardId" = "" ]; then 
    local jiraCardId=$(jira_card_id "$srcBranch")
  fi

  if [ "$reviewers" = "" ]; then 
    local reviewers="$DEFAULT_PR_REVIEWERS"
  fi

  if ( [ "$dryrun" = "dryrun" ] || [ "$dryrun" = "y" ] ); then 
    local dryrun="dryrun"
    echo "Running in DRYRUN mode..."
  fi
  
  cmdParts=()
  cmdParts+=$(cat << EOL
# hub pull-request -b "$dstBranch" -h "$srcBranch" -m "$jiraCardId $title" -m "$description" --reviewer "$reviewers"
gh pr create --base "$dstBranch" --head "$srcBranch" --title "$jiraCardId $title" --body "$description" --reviewer "$reviewers"
EOL
)
  
  cmd=$(printf '%s\n' "$(IFS=' '; printf '%s' "${cmdParts[*]}")")

  dryrun_or_run "$cmd" "$dryrun"
};

# === create_pr =========================

function create_pr(){
  usage=$(cat << EOL
Usage: 

create_pr "fixes bug"

create_pr "fixes bug" "this is a description for the pr"

DRYRUN=y create_pr "fixes bug" "this is a description for the pr"

DRYRUN=y create_pr "fixes bug" "\$(cat << EOL\nthis is a description for the pr\nthat consists of multiple lines\nEOL\n)"

DRYRUN=y REVIEWERS=tberbert JIRA_CARD_ID=2345 SRC_BRANCH="dcv/2345/feature-branch" DST_BRANCH="dcv/feature-branch" DRYRUN=y create_pr "fixes bug" "this is a description for the pr"
EOL
)
  
  if ( [ "$1" = "-h" ] || [ "$1" = "--help" ] ); then
    echo "$usage" 1>&2
    return
  fi

  local title="$1"
  local description="$2"

  local dstBranch="$DST_BRANCH"

  # if [ "$title" = "" ]; then echo "$usage" 1>&2; return; fi
  if [ "$title" = "" ]; then
    local title=$(git show -s --format='%s')
  fi
  
  if [ "$dstBranch" = "" ]; then dstBranch='dev'; fi

  if ( [ "$dryrun" = "dryrun" ] || [ "$dryrun" = "y" ] ); then 
    local dryrun="dryrun"
    echo "Running in DRYRUN mode..."
  fi
  
  cmd=$(cat << EOL
DRYRUN="$DRYRUN" JIRA_CARD_ID="$JIRA_CARD_ID" SRC_BRANCH="$SRC_BRANCH" create_pr_v1 "$dstBranch" "$title" "$description"
EOL
)

eval "$cmd"
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


# if [ ! "$1" = "" ]; then
#   create_pr "$1" "$2"
# else
#   echo "Successfully loaded git pr utilities"
#   echo

#   create_pr
# fi
