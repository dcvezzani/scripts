#!/bin/zsh

# ========================================
# get_path
function get_path() {
local obj="$1"
local _path="$2"

echo "$obj" | jq -r "$_path"
};


# ========================================
function left_pad() {
  local src="$1"
  local len="$2"
  local char="$3"
  if [[ $ZSH_VERSION ]]; then
    CMD=$(cat << EOL
echo \${(l($len)($char))src}
EOL
)
    # echo -e "$CMD"
    eval "$CMD"
  else
    CMD=$(cat << EOL
printf "%${char}${len}s" "$src"
EOL
)
    # echo -e "$CMD"
    eval "$CMD"
  fi
};


# ========================================
# get_date_range
function get_date_range() {

if [[ "$@" =~ '--help' ]]; then
cat << EOL
Usage: 
get_date_range 3/15
get_date_range 3/15 2022

Returns: {targetDate, nextDate}
EOL
  return 0
fi

local inputDate="$1"
local inputYear="$2"

if [[ "$inputDate" == "" ]]; then
local inputDay=$(date +"%d")
local inputMonth=$(date +"%m")
else
local inputDay=$(echo "$inputDate" | perl -pe 's/(^[^-\/]+)[-\/](.+)/$2/g')
local inputMonth=$(echo "$inputDate" | perl -pe 's/(^[^-\/]+)[-\/](.+)/$1/g')
fi

local inputDay=$(left_pad $inputDay 2 0)
local inputMonth=$(left_pad $inputMonth 2 0)
local inputDate="${inputMonth}-${inputDay}"

if [[ "$inputYear" == "" ]]; then
inputYear=$(date +"%Y")
fi

# theMonth=$(printf "%02s" $(echo "$inputDate" | perl -p -e "s#(\d+)[\/-](\d+)#\1#g"))
# targetDay=$(echo "$inputDate" | perl -p -e "s#(\d+)[\/-](\d+)#\2#g")
# targetDay=$(printf "%02s" "$targetDay")

targetDate="${inputYear}-${inputMonth}-${inputDay}"
targetDate2=$(echo "$targetDate 00:00:00" | perl -p -e "s#-#\/#g")
nextDate=$(date -v +1d -j -f "%Y/%m/%d %H:%M:%S" "$targetDate2" +"%Y-%m-%d")

cat << EOL
{"start":"$targetDate","stop":"$nextDate"}
EOL
};

# ========================================
# https://stackoverflow.com/questions/11283625/overwrite-last-line-on-terminal#answer-51858404
overwrite() { echo -e "\r\033[1A\033[0K$@"; }

# ========================================
# get_work_activity_for
function get_work_activity_for() {

if [[ "$@" =~ '--help' ]]; then
cat << EOL
Usage: 
get_work_activity_for 3/15
get_work_activity_for 3/15 2022

Returns: List of activities
- Activity: E.g., "[thrasher-web-ws] 41ca991: removes typo"
EOL
  return 0
fi

author='David Vezzani <dcvezzani@churchofjesuschrist.org>'

dateRange=$(get_date_range "$@" | jq -c '.')
targetDate=$(get_path $dateRange '.start')
cat << EOL
$targetDate
EOL
printf "." >&2

nextDate=$(get_path $dateRange '.stop')
projectsPath='/Users/dcvezzani/projects'
file='thrasher-fe'
results=$(
IFS=' ' && for file in $(cat /Users/dcvezzani/projects/github-projects.txt | grep -v '^-' | xargs); do
  IFS=$'\n' entries=($(git -C "$projectsPath/$file" --no-pager reflog --author="${author}" --format='%h: %s' --since="${targetDate} 00:00:00" --until="${nextDate} 00:00:00" | uniq))

  unset hashTracker
  declare -A hashTracker
  for entry in "${entries[@]}"
  do
    hashForEntry=$(echo "$entry" | perl -pe 's/\"/\\\"/g; s/^([^:]+): *(.*)/\{"project":"'"$file"'","description":"$2"\}/' | shasum | perl -pe 's/ +-$//')
    json=$(echo "$entry" | perl -pe 's/\"/\\\"/g; s/^([^:]+): *(.*)/\{\\"project\\":\\"'"$file"'\\",\\"commit\\":\\"$1\\",\\"description\\":\\"$2\\",\\"hash\\":\\"'"$hashForEntry"'\\"\}/')

    CMD=$(cat << EOL
if [[ ! "\${hashTracker[$hashForEntry]}" ]]; then
hashTracker[$hashForEntry]="$json"
fi
EOL
)
    # echo -e "$CMD"
    eval "$CMD"
  done
  
  # echo -e "${hashTracker[@]}"

  for key entry in ${(kv)hashTracker}; do
    # echo -e "- $entry"
    project=$(get_path "$entry" '.project')
    description=$(get_path "$entry" '.description')
    commit=$(get_path "$entry" '.commit')
    cat << EOL
- [$project] ${commit}: $description
EOL
  printf "." >&2
  done
done
)

# go to start of line, delete to end of line, go up one line
echo -e "\r\033[0K\033[1A"

cat << EOL

$(echo -e "$results" | sort)

EOL
};

get_work_activity_for "$@"
