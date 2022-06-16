#!/bin/bash

# === transform_version_line =========================

function transform_version_line() {
  usage=$(cat << EOL
Usage: transform_version_line '      <version>2.2.9.20220315-002</version>' '<version>' '<.*' '1.7.5'
EOL
)
  
  local line="$1"
  local match_token="$2"
  local match_token_end="$3"
  local version="$4"

  if [ "$line" = "" ]; then echo "$usage"; return; fi
  if [ "$match_token" = "" ]; then echo "$usage"; return; fi
  if [ "$match_token_end" = "" ]; then echo "$usage"; return; fi
  if [ "$version" = "" ]; then echo "$usage"; return; fi
  
  preString=$(echo "$line" | perl -p -e 's/^('"$match_token"').*/${1}/')
  workString=$(echo "$line" | perl -p -e 's/^('"$match_token"')(.*)/${2}/')
  newLine=$(echo "$workString" | perl -p -e 's/(.*)('"$match_token_end"')$/'"${preString}${version}"'${2}/')

  # cat << EOL
  # line: $line
  # preString: $preString
  # workString: $workString
  # newLine: $newLine
  # test: ${preString}${version}
  # EOL
  
  echo "$newLine"
}

# === tag_repo_java_interactive =========================

function tag_repo_java_interactive() {
  usage=$(cat << EOL
Usage: tag_repo_java_interactive 'pom.xml' '<version>' '<.*' '1.7.5'
Usage: tag_repo_java_interactive 'pom.xml' '<version>' '<.*' '1.7.5' dryrun
EOL
)

  local filename="$1"
  local match_token="$2"
  local match_token_end="$3"
  local version="$4"
  local dryrun="$5"
  
  if [ "$filename" = "" ]; then echo "$usage"; return; fi
  if [ "$match_token" = "" ]; then echo "$usage"; return; fi
  if [ "$match_token_end" = "" ]; then echo "$usage"; return; fi
  if [ "$version" = "" ]; then echo "$usage"; return; fi

  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi

# cat << EOL
# filename: $filename
# match_token: $match_token
# match_token_end: $match_token_end
# version: $version
# dryrun: $dryrun
# EOL

  # Gather all lines
  # - identify candidate rows for consideration after
  newLines=()
  targetLineIndexes=()
  index=1
  while IFS= read -r line; do
      chk=$(echo "$line" | grep "$match_token")
      if ( [ ! "$chk" = "" ] ); then
        targetLineIndexes+=($index)
      fi

      newLines+=("$line")
      ((index++))
  done < "$filename"
  newLines+=("")

  # Process lines
  # - if there is only one candidate, use that one
  if [ "${#targetLineIndexes[@]}" -eq 1 ]; then
    line="$newLines[$targetLineIndexes[1]]"
    newLine=$(transform_version_line "$line" "$match_token" "$match_token_end" "$version")
    newLines[$targetLineIndexes[1]]="$newLine"

  # - if there are more than one candidate, prompt user to select
  # - jump out after selection is made
  else
    actionResolved=n
    { for index in "${targetLineIndexes[@]}"
      do
        line="${newLines[$index]}"
        
        if ( [ ! "$actionResolved" = "y" ] ); then
          echo "Use this line? (y/n): $line"
          read -u 3 ans

          if [ "$ans" = "y" ]; then
            newLine=$(transform_version_line "$line" "$match_token" "$match_token_end" "$version")
            newLines[$index]="$newLine"
            actionResolved=y
            continue
          fi
        fi
    done  } 3<&0
  fi

  if [ "$dryrun" = "dryrun" ]; then
    IFS=$'\n'; printf %s "${newLines[*]}"
    return
  fi

  IFS=$'\n'; printf %s "${newLines[*]}" > "$filename"
}

# === user_prompt =========================

ans=''
function user_prompt() {
  unset ans
  usage=$(cat << EOL
Usage: user_prompt 'Commit updates?' 'git ls'
EOL
)

  local message="$1"
  local cmd="$2"

  if [ "$message" = "" ]; then echo "$usage"; return; fi
  if [ "$cmd" = "" ]; then echo "$usage"; return; fi
  
prompt=$(cat << EOL

$message (Ctrl-c to quit, Enter to continue)
-----------------------
$cmd

EOL
)
  printf "${prompt}\n"
  read ans
}

# === dryrun_or_run =========================

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
}

# === repo_name =========================

function repo_name() {
  printf $(awk '{split($0, array, "\/"); print array[5]}' <<< $(git config --get remote.origin.url)) | perl -p -e 's/\..*$//'
}

# === create_tag =========================

function create_tag() {
  usage=$(cat << EOL
Usage: create_tag "$version"
Usage: create_tag "$version" dryrun
EOL
)
  
  local version="$1"

  if [ "$version" = "" ]; then echo "$usage" 1>&2; return; fi
  
  repoName=$(repo_name)
  tagAnnotation="${repoName}-v${version}"
cmd=$(cat << EOL
git tag -a "$tagAnnotation" -m "Version ${version}"
EOL
)

  (user_prompt 'Create tag?' "$cmd") 1>&2
  (dryrun_or_run "$cmd" "$dryrun") 1>&2

  git tag | grep "$version" 1>&2

  printf "$tagAnnotation"
}

# === push_to_remote =========================

function push_to_remote() {
  usage=$(cat << EOL
Usage: push_to_remote "$tagAnnotation"
Usage: push_to_remote "$tagAnnotation" dryrun
EOL
)
  
  local tagAnnotation="$1"
  local dryrun="$2"

  if [ "$tagAnnotation" = "" ]; then echo "$usage" 1>&2; return; fi
  
  branch=$(git branch | grep -E '^\*' | awk '{print $2}')
  
cmd=$(cat << EOL
git push origin $branch
git push origin $tagAnnotation
EOL
)
 
  (user_prompt 'Push to remote?' "$cmd") 1>&2
  (dryrun_or_run "$cmd" "$dryrun") 1>&2
}

# === commit_updates =========================

function commit_updates() {
  usage=$(cat << EOL
Usage: commit_updates 1.7.5
EOL
)
  
  local version="$1"
  local dryrun="$2"
  local cmd="$3"

  if [ "$version" = "" ]; then echo "$usage" 1>&2; return; fi

local cmd=$(cat << EOL
$cmd
git commit -m "Version $version"
EOL
)
  
  (user_prompt 'Commit updates?' "$cmd") 1>&2
  (dryrun_or_run "$cmd" "$dryrun") 1>&2
}

# === _tag_repo_java =========================

function _tag_repo_java() {
  usage=$(cat << 'EOL'
Usage: _tag_repo_java "$cmd" 1.7.5
Usage: _tag_repo_java "$cmd" 1.7.5 dryrun
EOL
)
  
  local java_cmd="$1"
  local version="$2"
  local dryrun="$3"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  dryrun_or_run "$java_cmd" "$dryrun"

cmd=$(cat << EOL
git add pom.xml devops/pipelines.yml
EOL
)

  run_and_publish_tag "$version" "$cmd" "$dryrun"
  
  echo "DONE"
}

# === tag_repo_cms =========================

function tag_repo_cms() {
  usage=$(cat << EOL
Usage: tag_repo_cms 1.7.5
Usage: tag_repo_cms 1.7.5 dryrun
EOL
)
  
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  repoName=$(repo_name)

cmd=$(cat << EOL
tag_repo_java_interactive 'pom.xml' '^.*<version>' '<.*' "$version"
tag_repo_java_interactive 'pom.xml' '^.*<artifactId>' '<.*' "$repoName"
tag_repo_java_interactive 'pom.xml' '^.*<name>' '<.*' "$repoName"
tag_repo_java_interactive 'devops/pipelines.yml' "^  value: \\'" "\\'.*" "${repoName}-${version}.xar"
git diff --exit-code pom.xml devops/pipelines.yml
EOL
)

_tag_repo_java "$cmd" "$version" "$dryrun"
}

# === tag_repo_java =========================

function tag_repo_java() {
  usage=$(cat << EOL
Usage: tag_repo_java 1.7.5
Usage: tag_repo_java 1.7.5 dryrun
EOL
)
  
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  repoName=$(repo_name)

cmd=$(cat << EOL
tag_repo_java_interactive 'pom.xml' '^.*<version>' '<.*' "$version"
EOL
)

_tag_repo_java "$cmd" "$version" "$dryrun"
}

# === npm_install =========================

npm_install=$(printf "npm i --legacy-peer-deps")

# === tag_repo_node =========================

function tag_repo_node() {
  usage=$(cat << EOL
Usage: tag_repo_node 1.7.5
Usage: tag_repo_node 1.7.5 dryrun
EOL
)

  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
cmd=$(cat << EOL
$npm_install
perl -p -i -e 's/("version": ")([^"]+)(.*)/\${1}'"$version"'\${3}/' package.json
git diff --exit-code package.json
EOL
)
  dryrun_or_run "$cmd" "$dryrun"
  
cmd=$(cat << EOL
git add package.json package-lock.json
EOL
)
 
  run_and_publish_tag "$version" "$cmd" "$dryrun"

  echo "DONE"
}

# === run_and_publish_tag =========================

function run_and_publish_tag() {
  usage=$(cat << 'EOL'
Usage: run_and_publish_tag 1.7.5 $cmd
Usage: run_and_publish_tag 1.7.5 $cmd dryrun
EOL
)
  
  local version="$1"
  local cmd="$2"
  local dryrun="$3"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  commit_updates "$version" "$dryrun" "$cmd"
  local tagAnnotation=$(create_tag "$version" "$dryrun")
  push_to_remote "$tagAnnotation" "$dryrun"
}

# === commit_and_publish_tag =========================

function commit_and_publish_tag() {
  usage=$(cat << EOL
Usage: commit_and_publish_tag 1.7.5
Usage: commit_and_publish_tag 1.7.5 dryrun
EOL
)
  
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  commit_updates "$version" "$dryrun"
  local tagAnnotation=$(create_tag "$version" "$dryrun")
  push_to_remote "$tagAnnotation" "$dryrun"
}

# === apply_and_publish_tag =========================

function apply_and_publish_tag() {
  usage=$(cat << EOL
Usage: apply_and_publish_tag 1.7.5
Usage: apply_and_publish_tag 1.7.5 dryrun
EOL
)
  
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then echo "$usage"; return; fi
  if [ "$dryrun" = "dryrun" ]; then echo "Running in DRYRUN mode..."; fi
  
  local tagAnnotation=$(create_tag "$version" "$dryrun")
  push_to_remote "$tagAnnotation" "$dryrun"
}

# === utililities loaded welcome message =========================

cat << EOL
Git tagging tools loaded

$(tag_repo_node)
$(tag_repo_java)
$(tag_repo_cms)
$(commit_and_publish_tag)
$(apply_and_publish_tag)
EOL

