#!/bin/bash

journalPath="/Users/dcvezzani/Dropbox/journal/current"

input_target_date="$1"
input_scope="$2"

if [[ $FOR_TIMESHEET == "true" ]]; then 
VERBOSE="false"
HIDE_DAILY_HOURS="true"
fi

if [[ $input_target_date == 'week' ]]; then
  input_scope="$input_target_date"
  unset input_target_date
fi

if [[ $input_target_date == 'yesterday' ]]; then
  input_target_date=$(date -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $input_target_date == 'tomorrow' ]]; then
  input_target_date=$(date -v +1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $input_target_date == 'last-friday' ]]; then
  input_target_date=$(date -v -Sat -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ -z $input_target_date ]]; then
  input_target_date=$(date '+%Y-%m-%d')
fi

if [[ -z $input_scope ]]; then
  input_scope="day"
fi

compile_work_hours() {
local scope="$1"
NODE_PATH=$(npm root --quiet --location=global) /Users/dcvezzani/scripts/work-hours.js $scope
}

function usage() {
cat << EOL
Gather work hours for the week along with a summary of activities.

~/scripts/work-hours.sh [<target_date> [<scope>]]

E.g.,
# get work hours for current day
~/scripts/work-hours.sh

# get work hours for a specific day
~/scripts/work-hours.sh 2023-03-15

# get work hours for the week that includes the given day
~/scripts/work-hours.sh 2023-03-15 week
EOL
}

function target_date() {
  local _target_date="$1"
  local day_offset="$2"
  local date_format="$3"

  if [[ -z $day_offset ]]; then
    local day_offset=0
  fi

  if [[ -z $date_format ]]; then
    local date_format='%Y-%m-%d'
  fi

  if [[ -z $input_target_date ]]; then
    input_target_date=$(date '+%Y-%m-%d')
  fi

  # CMD=$(cat << EOL
# date -jf '%Y-%m-%d' $TARGET_DATE $date_format
# EOL
# )
  # echo "$CMD"
  
  date -v -Sat -v +${day_offset}d -jf '%Y-%m-%d' "$_target_date" "$date_format"
};


function for_the_day() {
local _target_date="$1"

local datestamp=$(date -jf "%Y-%m-%d" "$_target_date" "+%F (%a)")
local filename=$(echo "work-log-$(date -jf "%Y-%m-%d" "$_target_date" "+%F-%a" | perl -ne 'print lc').md")


if [[ ! -e "$journalPath/$filename" ]]; then
  echo "File does not exist: $journalPath/$filename" >&2
  return 1
fi

local summary=$(cat "$journalPath/$filename" | perl -ne '/^[0-9]/ && print')

local summary_formatted_compiled=$(echo "$summary" | compile_work_hours)
local summary_group_formatted_compiled=$(echo "$summary" | compile_work_hours "group")

if [[ $VERBOSE != "false" ]]; then 
  local summary_formatted=$(cat << EOL
Activity entries
----------------------------
$summary

Percentages breakdown (by activity)
----------------------------
$summary_formatted_compiled

Percentages breakdown (by group)
----------------------------
$summary_group_formatted_compiled
EOL
echo ' '
)
fi

if [[ $VERBOSE == "false" ]]; then 
  if [[ $HIDE_DAILY_HOURS == "true" ]]; then 
cat << EOL
### $datestamp

Activity
----------------------------
$(echo "$summary_formatted_compiled" | perl -pe 's/^[^;]+; *[^;]+; *//' | sort | grep -v standup)

Hours for the day
----------------------------
8
EOL
  else
cat << EOL
### $datestamp

Activity
----------------------------
$(echo "$summary_formatted_compiled" | perl -pe 's/^[^;]+; *[^;]+; *//' | sort | grep -v standup)

Hours for the day
----------------------------
$(echo "$summary" | perl -pe 's/^([ -]*)([^;]+);.*/$2/' | /Users/dcvezzani/scripts/add.sh)
EOL
  fi

else
cat << EOL
### $datestamp

$summary_formatted
Standup bullets (by activity)
----------------------------
$(echo "$summary_formatted_compiled" | perl -pe 's/^[^;]+; *[^;]+; *//' | sort | grep -v standup)

Standup bullets (by group)
----------------------------
$(echo "$summary_group_formatted_compiled" | perl -pe 's/^[^;]+; *[^;]+; *//' | sort | grep -v standup)

Hours for the day
----------------------------
$(echo "$summary" | perl -pe 's/^([ -]*)([^;]+);.*/$2/' | /Users/dcvezzani/scripts/add.sh)
EOL
fi

}

function for_the_week() {
local _target_date="$1"

local datestamp=$(date -jf "%Y-%m-%d" "$_target_date" "+%Y-%m-%d")
local satDate=$(target_date $datestamp 0 "+%Y-%m-%d")

local CMD_report=$(cat << EOL
for i in {0..6}; do
  local next_target_date=\$(target_date $satDate \$i "+%Y-%m-%d" | awk '{print tolower(\$0)}')
  for_the_day \$next_target_date
  if [[ \$? == 0 ]]; then echo; fi
done
EOL
)

local report=$(eval "$CMD_report")
local totalHours=$(echo "$report" | grep -E '^[0-9\.]+$' | /Users/dcvezzani/scripts/add.sh)

echo
cat << EOL
$report

Total hours (for the week) 
============================
$totalHours
EOL
}

if [[ $input_scope == "week" ]]; then
CMD=$(cat << EOL
for_the_week $input_target_date
EOL
)
else
CMD=$(cat << EOL
for_the_day $input_target_date
EOL
)
fi

# echo "$CMD"
eval "$CMD"
