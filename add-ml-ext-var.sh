function logit() {
msg="$1"
echo -e "\n####################\n${msg}"
};

function promptit() {
msg="$1"
echo -e "\n####################\n${msg} (y/n)"
};

function check_update() {
for proj in $(ls-projects cms); do
# echo "# ================= $proj"
grep -r 'Marklogic Extension Variables' "${proj}"/devops/*.yml 2>&1 >/dev/null
returnCode=$?

if [[ $returnCode != 0 ]]; then
echo "$proj"
fi
done
}

function check_commit() {
for proj in $(ls-projects cms); do
cd "$proj"
git log | grep 'adds Marklogic Extension Variables Library Variable group' 2>&1 >/dev/null
returnCode=$?

if [[ $returnCode != 0 ]]; then
echo "$proj"
fi
done
}

function process() {
proj="$1"

CMD=$(cat << EOL
# cd to project dir
cd "$proj"

git log | grep 'adds Marklogic Extension Variables Library Variable group'
returnCode=\$?

if [[ \$returnCode == 0 ]]; then
logit "Project already updated; doing nothing for now"
return 1
fi

# stash pom and pipelines
logit "Stash target files"
git-ls a | grep "pom.xml" 2>&1 >/dev/null
returnCode=\$?

git-ls a | grep "devops\/pipelines.yml" 2>&1 >/dev/null
returnCode2=\$?

git stash list | grep "pom_and_pipelines" 2>&1 >/dev/null
returnCode3=\$?

if [[ \$returnCode == 0 ]] && [[ \$returnCode2 == 0 ]] && [[ \$returnCode3 != 0 ]]; then
git stash push -m "pom_and_pipelines" -- pom.xml devops/pipelines.yml
fi

# check for other modified files
logit "Modified files"
git-ls m
modifiedLinesCnt=\$(git-ls m | wc -l | xargs)

# stash modified files
if [[ \$modifiedLinesCnt > 0 ]]; then
  promptit "There are currently modified files; stash?"
  unset ans
  read ans

  if [[ \$ans == "y" ]]; then
  git stash -- \$(git-ls m | xargs)
  else
  logit "Unsupported action; doing nothing for now"
  return 1
  fi
fi

# checkout dev and get latest
git co dev
git pull origin dev

# check for feature branch; if not exists, create new feature branch
featureBranchName=\$(git ls | grep 'marklogic-extension-variables' | perl -pe 's/\* //')

if [[ \$featureBranchName == "" ]]; then
  git co -b dcv/KPP-88/add-marklogic-extension-variables
else
  git co dcv/KPP-88/add-marklogic-extension-variables
  git merge dev
fi

# stash apply pom and pipelines
stashIndex=\$(git stash list | grep pom_and_pipelines | head -1 | perl -pe 's/stash\@\{([^\}]+).*/\$1/')
git stash apply stash@{\$stashIndex}
returnCode=\$?

if [[ \$returnCode > 0 ]]; then
logit "Please resolve conflict before running script again"
return 1
fi

EOL
)

# echo -e "$CMD"
eval "$CMD"
}

function publish() {

CMD=$(cat << EOL

# add and commit
git add pom.xml devops/pipelines.yml
git commit -m "adds Marklogic Extension Variables Library Variable group"

# push and pr
git push origin dcv/KPP-88/add-marklogic-extension-variables

which create_pr 2>&1 >/dev/null
returnCode=\$?

if [[ $returnCode > 0 ]]; then
  load-git-pr
fi

create_pr
git-commit-details

EOL
)

# echo -e "$CMD"
eval "$CMD"
}
