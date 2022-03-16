#!/bin/bash

# trap ctrl_c INT

# function ctrl_c() {
#   echo "** Trapped CTRL-C"
#   return
# }

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

function tag_repo_java_interactive() {
  usage=$(cat << EOL
Usage: tag_repo_java_interactive 'pom.xml' '<version>' '<.*' '1.7.5'
Usage: tag_repo_java_interactive 'pom.xml' '<version>' '<.*' '1.7.5' 'y'
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
  if [ "$dryrun" = "" ]; then local dryrun="n"; fi

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

  if [ "$dryrun" = "y" ]; then
    IFS=$'\n'; printf %s "${newLines[*]}"
    return
  fi

  IFS=$'\n'; printf %s "${newLines[*]}" > "$filename"
}

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

function tag_repo_java() {
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then
    echo "Usage: tag_repo '1.7.5'"
    return
  fi

  repoName=$(echo $(awk '{split($0, array, "\/"); print array[5]}' <<< $(git config --get remote.origin.url)) | perl -p -e 's/\..*$//')

cmd=$(cat << EOL
tag_repo_java_interactive 'pom.xml' '^.*<version>' '<.*' "$version"
tag_repo_java_interactive 'devops/pipelines.yml' "^  XarFileName: \\'" "\\'.*" "${repoName}-${version}.xar"
git diff --exit-code
EOL
)

  if [ ! "$dryrun" = "dryrun" ]; then
    echo -e "$cmd"
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi

cmd=$(cat << EOL
git add pom.xml devops/pipelines.yml
git commit -m "Version $version"
EOL
)
  
  (user_prompt 'Commit updates?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi

  tagAnnotation="${repoName}-v${version}"
cmd=$(cat << EOL
git tag -a "$tagAnnotation" -m "Version ${version}"
EOL
)

  (user_prompt 'Create tag?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi

  git tag | grep "$version"
  
  branch=$(git branch | grep -E '^\*' | awk '{print $2}')
  
cmd=$(cat << EOL
git push origin $branch
git push origin $tagAnnotation
EOL
)
 
  (user_prompt 'Push to remote?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    echo -e "$cmd"
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi

  echo "DONE"
}

function tag_repo_node() {
  local version="$1"
  local dryrun="$2"

  if [ "$version" = "" ]; then
    echo "Usage: tag_repo '1.7.5'"
    return
  fi

  repoName=$(echo $(awk '{split($0, array, "\/"); print array[5]}' <<< $(git config --get remote.origin.url)) | perl -p -e 's/\..*$//')

  perl -p -i -e 's/("version": ")([^"]+)(.*)/${1}'"$version"'${3}/' package.json

  git diff --exit-code package.json

cmd=$(cat << EOL
git add package.json
git commit -m "Version $version"
EOL
)
  
  (user_prompt 'Commit updates?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi
  
  tagAnnotation="${repoName}-v${version}"
cmd=$(cat << EOL
git tag -a "$tagAnnotation" -m "Version ${version}";
EOL
)
  
  (user_prompt 'Create tag?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi
  
  git tag | grep "$version"
  
  branch=$(git branch | grep -E '^\*' | awk '{print $2}')
  
cmd=$(cat << EOL
git push origin $branch
git push origin $tagAnnotation
EOL
)
  
  (user_prompt 'Push to remote?' "$cmd")

  if [ ! "$dryrun" = "dryrun" ]; then
    eval "$cmd"
  else
    echo -e "DRYRUN: \n$cmd"
  fi

  echo "DONE"
}


cat << EOL
Git tagging tools loaded

Usage:
- tag_repo_node 2.0.4
- tag_repo_java 2.0.4
EOL
