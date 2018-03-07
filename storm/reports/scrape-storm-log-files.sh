#!/bin/bash

hostid=$(hostname)
REPORT_DATE=$1

if [ "$REPORT_DATE" == '' ]; then
	REPORT_DATE=$(date -u +"%Y-%m-%d")
fi

# month_day=$(echo "$REPORT_DATE" | sed 's/^[^ ]* *\([^ ]* *[^ ]*\).*$/\1/g')#; echo "$month_day"

month_day_raw=$(date --date="$REPORT_DATE" "+%b %d") 2> /dev/null
if [ "$?" != '0' ]; then
	the_month=$(echo "$REPORT_DATE" | sed 's/[^-]*-\([^-]*\)-[^-]*$/\1/g'); #echo "$the_month"
	the_day=$(echo "$REPORT_DATE" | sed 's/[^-]*-[^-]*-\([^-]*\)$/\1/g'); #echo "$the_day"
	month_day_raw=$(date -v"$the_month"m -v"$the_day"d "+%b %d")
fi

month_day=$(echo "$month_day_raw" | sed 's/^\([^ ]* \)0/\1 /g')

# ls -latr /var/log/storm/freeswitch/
# ls -latr /var/log/storm/freeswitch/ | sed '/Dec  4/!d; s#^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\(.*\)$#\1#g; /freeswitch.log.2017-11-28-19-00-56.1/d; /freeswitch\.log/!d'

ds=$(echo "$REPORT_DATE" | sed 's/-//g'); #echo "$ds"

# echo "$hostid, $REPORT_DATE, $month_day_raw, $month_day"
printf "\nScraping log content for $REPORT_DATE ($hostid, $REPORT_DATE, $month_day_raw, $month_day)\n"


fs_files=$(ls -latr /var/log/storm/freeswitch/ | sed '/'"$month_day"'/!d; s#^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\(.*\)$#\1#g; /freeswitch.log.2017-11-28-19-00-56.1/d; /freeswitch.log.2017-12-05-22-34-00.1/d; /freeswitch.log.2017-12-05-06-47-11.1/d; /freeswitch\.log/!d')
# fs_files=$(ls /var/log/storm/telecom/freeswitch.log)
printf "\nScraping $(echo "$fs_files" | wc -w | xargs) files ($(printf "$fs_files" | xargs)) for Freeswitch log content\n"

echo '' > /tmp/fs-${hostid}-${ds}.log
for file in $fs_files; do
	cat "/var/log/storm/freeswitch/$file" >> /tmp/fs-${hostid}-${ds}.log
	# cat "$file" >> /tmp/fs-${hostid}-${ds}.log
done

# ls -latr /var/log/storm/lightstreamer/ | sed '/Dec  4/!d; s#^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\(.*\)$#\1#g; /storm\.log/!d'


ls_files=$(ls -latr /var/log/storm/lightstreamer/ | sed '/'"$month_day"'/!d; s#^[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\(.*\)$#\1#g; /storm\.log/!d')
printf "\nScraping $(echo "$ls_files" | wc -w | xargs) files ($(printf "$ls_files" | xargs)) for Lightstreamer log content\n"

echo '' > /tmp/ls-${hostid}-${ds}.log
for file in $ls_files; do
	cat "/var/log/storm/lightstreamer/$file" >> /tmp/ls-${hostid}-${ds}.log
done


# node log files seem to wrap between the previous day and the target day
one_day_in_ms=$(echo $((60*60*24))) #86400000
start_date_in_ms=$(date --date="$REPORT_DATE" "+%s" 2> /dev/null) #Ubuntu compatible
if [ "$?" != '0' ]; then
	the_year=$(echo "$REPORT_DATE" | sed 's/\([^-]*\)-[^-]*-[^-]*$/\1/g');  #echo "$the_year"
	the_month=$(echo "$REPORT_DATE" | sed 's/[^-]*-\([^-]*\)-[^-]*$/\1/g'); #echo "$the_month"
	the_day=$(echo "$REPORT_DATE" | sed 's/[^-]*-[^-]*-\([^-]*\)$/\1/g');   #echo "$the_day"
	start_date_in_ms=$(echo $(($(date -v"$the_year"y -v"$the_month"m -v"$the_day"d -v0H -v0M -v0S +'%s')))) #Mac OSX compatible
fi

end_date_in_ms=$((start_date_in_ms + one_day_in_ms))
start_date=$(echo $REPORT_DATE | sed 's/-/\./g')

end_date=$(date -r "$end_date_in_ms" +%Y.%m.%d) 2> /dev/null #Mac OSX compatible
if [ "$?" != '0' ]; then
	end_date=$(date -d "1970-01-01 UTC + $end_date_in_ms seconds" +%Y.%m.%d) #Ubuntu compatible
fi

# echo ">>> $start_date - $end_date"
# echo ">>>  /var/log/storm/lag_monitor/node-$start_date.log" 
# echo ">>>  /var/log/storm/lag_monitor/node-$end_date.log" 
# node-2017.12.15.log

# start_date=2017.12.14 end_date=2017.12.15
node_files=$(ls -1 "/var/log/storm/lag_monitor/node-$start_date.log" "/var/log/storm/lag_monitor/node-$end_date.log" | xargs)
printf "\nScraping $(echo "$node_files" | wc -w | xargs) files ($(printf "$node_files" | xargs)) for Node log content\n"

echo '' > /tmp/node-${hostid}-${ds}.log
for file in $node_files; do
	cat "$file" >> /tmp/node-${hostid}-${ds}.log
done

