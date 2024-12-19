read_multiline_input() {
  echo "Enter your input (type 'END' to finish):" 1>&2
  local input=""
  while IFS= read -r line; do
    if [[ "$line" == "END" ]] || [[ "$line" == "." ]]; then
      break
    fi
    input+="$line"$'\n'
  done
  echo "$input"
}

getFirstModifiedFile() {
local firstLine=$(git st | grep -e '\tmodified' | head -1 2>&1)
echo "$firstLine" | perl -p -e 's/^\s+modified:\s+//'
}

gitcm() {
local file="$1"
if [[ -z $file ]]; then
  local file=$(getFirstModifiedFile)
fi

git diff "$file"

local comment=$(read_multiline_input)
git commit -o "$file" -m "$comment"
}

