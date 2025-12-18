#!/bin/bash

show_help() {
  cat << EOF
Usage: ./git-commit.sh [commit message]

Creates a Git commit with a message prefixed by the Jira ID extracted from the current branch name.

Branch name format expected:
  category/JIRA-ID-description
  e.g., feature/WFRPUB-1174-fe-all-product-pages-are-rendering-an

Examples:

  ./git-commit.sh "Fixes layout issue on product page"

  cat << EOM | ./git-commit.sh
  Multi-line
  commit message
  EOM

Options:
  --help        Show this help message and exit
EOF
}

# Show help if --help is passed or no arguments and no piped input
if [[ "$1" == "--help" || ( -t 0 && $# -eq 0 ) ]]; then
  show_help
  exit 0
fi

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Extract the Jira ID (e.g., WFRPUB-1174) from the branch name
jira_id=$(echo "$branch_name" | grep -oE '[A-Z]+-[0-9]+')

# Read the commit message from argument or stdin
if [ -t 0 ]; then
  commit_msg="$1"
else
  commit_msg=$(cat)
fi

# Check if Jira ID was found
# if [ -z "$jira_id" ]; then
#   echo "Error: Could not extract Jira ID from branch name '$branch_name'"
#   exit 1
# fi

# Combine Jira ID (if it exists) and commit message
if [ -z "$jira_id" ]; then
full_msg="$commit_msg"
else
full_msg="$jira_id $commit_msg"
fi

shift

# Make the commit
git commit -m "$full_msg" $*

