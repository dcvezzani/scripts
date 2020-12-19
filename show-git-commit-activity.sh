inputDate="$1"
inputYear="$2"
# inputDate="8/1"

author='David Vezzani <dcvezzani@churchofjesuschrist.org>'
# author='David C. Vezzani <David.Vezzani@churchofjesuschrist.org>'

if [ "$inputDate" == "" ]; then
inputDate=$(date +"%m-%d")
fi

if [ "$inputYear" == "" ]; then
inputYear=$(date +"%Y")
fi

checkForSingleDay=$(echo "$inputDate" | perl -p -e "s#\d+##g" | xargs | wc -m | xargs)
if [ "$checkForSingleDay" == "0" ]; then
  currentMonth=$(date +"%m")
  inputDate=$(date -j -f "%Y/%m/%d %H:%M:%S" "${inputYear}/${currentMonth}/${inputDate} 00:00:00" +"%m-%d")
fi

if [ ! "$VERBOSE" == "0" ]; then
  echo ">>> inputDate: '$inputDate'"
fi

projectsPath='/Users/dcvezzani/projects'
theMonth=$(printf "%02s" $(echo "$inputDate" | perl -p -e "s#(\d+)[\/-](\d+)#\1#g"))
targetDay=$(echo "$inputDate" | perl -p -e "s#(\d+)[\/-](\d+)#\2#g")
targetDay=$(printf "%02s" "$targetDay")

targetDate="${inputYear}-${theMonth}-${targetDay}"
targetDate2=$(echo "$targetDate 00:00:00" | perl -p -e "s#-#\/#g")
nextDate=$(date -v +1d -j -f "%Y/%m/%d %H:%M:%S" "$targetDate2" +"%Y-%m-%d")

if [ ! "$VERBOSE" == "0" ]; then
  echo "${VERBOSE} Showing git commit activity from '${targetDate}' to '${nextDate}' ...\n"
  echo "cmd: \ngit reflog --author=\"${author}\" --format='%s' --since=\"${targetDate} 00:00:00\" --until=\"${nextDate} 00:00:00\" | uniq\n"
fi


results=$(for file in $(cat /Users/dcvezzani/projects/github-projects.txt); do
  # echo "checking $file..."
  # cd "$projectsPath"
  # gitLogResults=$(git -C "$projectsPath/$file" --no-pager log --author="${author}" --since="${targetDate} 00:00:00" --until="${nextDate} 00:00:00" --pretty=oneline --abbrev-commit)
  # gitLogResults=$(git reflog --date=iso --format='%C(auto)%h %<|(20)%gd %C(blue)%cr%C(reset) %gs (%s)' --since="${targetDate} 00:00:00" --until="${nextDate} 00:00:00")
  # gitLogResults=$(git -C "$projectsPath/$file" --no-pager reflog --format='%s' --since="${targetDate} 00:00:00" --until="${nextDate} 00:00:00")

  gitLogResults=$(git -C "$projectsPath/$file" --no-pager reflog --author="${author}" --format='%h: %s' --since="${targetDate} 00:00:00" --until="${nextDate} 00:00:00" | uniq)

  # Show more details when logging
  # https://git-scm.com/docs/pretty-formats
  # git reflog --date=iso --format='%C(auto)%h %<|(20)%gd %C(blue)%cr%C(reset) %C(green)%ce%C(reset) %gs (%s)' --since="2020-11-30 00:00:00" --until="2020-12-01 00:00:00" | grep "${authorEmail}"
  
  gitLogResultLines=$(echo "$gitLogResults" | wc -l | xargs)
  # echo "$gitLogResultLines"
  if [ ! "$gitLogResultLines" == "1" ] || [ ! "$gitLogResults" == "" ]; then
    gitLogResultsFormatted=$(echo "$gitLogResults" | perl -p -e "s#^(.*)\$#[$file] \1#g")
    echo "$gitLogResultsFormatted"
  fi
done)

if [ "$PBCOPY" == "1" ]; then
  echo "$results" | grep -v "This is a combination" | grep -v "Merge" | pbcopy
else
  echo "$results" | grep -v "This is a combination" | grep -v "Merge"
fi


