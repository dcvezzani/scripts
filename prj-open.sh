#!/bin/bash

subject="$1"
tier="$2"

projectPath=$(~/scripts/cf-get-project-source.js $subject $tier)

if [[ $projectPath != "" ]]; then
  echo "Opening project: '$projectPath'..."
  cd $projectPath
else
  echo "Project path does not exist: '${projectPath}'"
fi
