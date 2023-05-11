#!/bin/bash

target_date="$1"
journal_dir='/Users/dcvezzani/Dropbox/journal/current'

function target_date() {
  day_offset="$1"
  date_format="$2"

  if [[ -z $day_offset ]]; then
    day_offset=0
  fi

  if [[ -z $date_format ]]; then
    date_format='%Y-%m-%d'
  fi

  if [[ -z $target_date ]]; then
    target_date=$(date '+%Y-%m-%d')
  fi

  # CMD=$(cat << EOL
# date -jf '%Y-%m-%d' $TARGET_DATE $date_format
# EOL
# )
  # echo "$CMD"
  
  date -v -Sat -v +${day_offset}d -jf '%Y-%m-%d' "$target_date" "$date_format"
};

# datestamp=$(date "+%F")

cd "$journal_dir"

satDate=$(target_date 0 "+%Y-%m-%d")

workLogFiles=$(for i in {0..6}
do
   datestamp=$(target_date $i "+%Y-%m-%d-%a" | awk '{print tolower($0)}')
   echo "work-log-${datestamp}.md"
done | xargs
)

# echo -e "$workLogFiles"

datestamp=$(target_date 6 "+%Y-%m-%d-%a" | awk '{print tolower($0)}')

function scrapeWorkLogEntries() {
file="$1"

if [[ ! -e "$file" ]]; then
  return
fi

echo
cat << EOL
$file
===================================
EOL

cat "$file" | perl -ne '/^[0-9]/ && print'
}

CMD_workLogFiles=$(cat << EOL
for file in $workLogFiles; do
  scrapeWorkLogEntries "\$file"
done > "timesheet-report-${datestamp}.txt"
EOL
)
eval "$CMD_workLogFiles"

# for file in $(eval "$CMD_workLogFiles"); do
# echo
# cat << EOL
# $file
# ===================================
# EOL
# 
# cat "$file" | perl -ne '/^[0-9]/ && print'
# done > "timesheet-report-${datestamp}.txt"

cat << EOL
>>>work log entries scraped to: 
mvim timesheet-report-${datestamp}.txt

EOL

node ~/scripts/format-timesheet-report.js "timesheet-report-${datestamp}.txt"

# JQ Functions

createSortedArray=$(cat << EOL
def createSortedArray: . | to_entries | map("- [ ] " + .key + ": " + (.value | tostring)) | sort
EOL
)

collectTimesByProjectAndDay=$(cat << 'EOL'
def collectTimesByProjectAndDay: . | to_entries | map(. as $dayEntries | $dayEntries | .key as $day | $dayEntries | $day + ": " + (.value.totals.ztotal | tostring) )
EOL
)

sumProjectTimeForWeek=$(cat << 'EOL'
def sumProjectTimeForWeek: . | ["total---------> " + (.totals.ztotal | tostring)]
EOL
)

# Reports

## Basic report (deprecated?)
report=$(cat "timesheet-report-${datestamp}.json" | jq 'def createSortedArray: . | to_entries | map("- [ ] " + .key + ": " + (.value | tostring)) | sort; .byDay.entries | to_entries | map(select(.key != "currentKey")) | map({(.key): (.value | .totals | createSortedArray)})')

## Time charged by day
reportByDay=$(cat "timesheet-report-${datestamp}.json" | jq --sort-keys 'def createSortedArray: . | to_entries | map("- [ ] " + .key + ": " + (.value | tostring)) | sort; .byDay as $byDay | $byDay | .entries | to_entries | map(select(.key != "currentKey")) | (map({(.key): (.value | .totals | createSortedArray)}) | sort) + [{"totalHrsForWeek": ($byDay | .ztotal)}]')

## Time charged by project and day
CMD_reportByProject=$(cat << EOL
cat "timesheet-report-${datestamp}.json" | jq --sort-keys '${createSortedArray}; ${collectTimesByProjectAndDay}; ${sumProjectTimeForWeek}; .byProject as \$byProject | \$byProject | .entries | to_entries | map(select(.key != "currentKey")) | (map({(.key): (.value as \$projectValue | \$projectValue | .days | collectTimesByProjectAndDay + (\$projectValue | sumProjectTimeForWeek))}) | sort) + [{"totalHrsForWeek": (\$byProject | .ztotal)}]'
EOL
)
reportByProject=$(eval "$CMD_reportByProject")

## Time charged by project and jiraId for the week
CMD_reportByProjectAndJiraId=$(cat << EOL
cat "timesheet-report-${datestamp}.json" | jq --sort-keys '${createSortedArray}; ${collectTimesByProjectAndDay}; ${sumProjectTimeForWeek}; .byProject as \$byProject | \$byProject | .entries | to_entries | map(select(.key != "currentKey")) | (map({(.key): (.value as \$projectValue | \$projectValue | (.totals) )}) | sort) + [{"totalHrsForWeek": (\$byProject | .ztotal)}]'
EOL
)
reportByProjectAndJiraId=$(eval "$CMD_reportByProjectAndJiraId")


# Serialize

echo "$reportByDay"
echo
echo "$reportByDay" > "timesheet-summary-by-day-${datestamp}.json"
echo "$reportByProject" > "timesheet-summary-by-project-${datestamp}.json"
echo "$reportByProjectAndJiraId" > "timesheet-summary-by-project-and-jira-id-${datestamp}.json"

cat << EOL
>>>summaries written to: 
mvim -p \\
${journal_dir}/timesheet-summary-by-day-${datestamp}.json \\
${journal_dir}/timesheet-summary-by-project-${datestamp}.json \\
${journal_dir}/timesheet-summary-by-project-and-jira-id-${datestamp}.json
EOL

echo
cat << EOL
Enter your time: https://icsworkfront.my.workfront.com/timesheets/own
EOL

echo


# cat "timesheet-report-${datestamp}.json" | jq '. | entries'
# 
# # get filtered keys
# cat timesheet-report-2022-08-26.json | jq '. | to_entries | map(select(.key != "currentKey")) | map({totals: (.value | .totals)} + {key})'
# 
# # get report; days and totals
# cat timesheet-report-2022-08-26.json | jq '. | to_entries | map(select(.key != "currentKey")) | map({(.key): (.value | .totals)})'
# 
#   {
#     "2022-08-26-fri": {
#       "MISRF": 3,
#       "admin": 2,
#       "LDSC": 1,
#       "CHREC": 0.5,
#       "THRASH": 1.5
#     }
#   }
