#!/bin/bash

# scp /Users/dcvezzani/scripts/scrape-lag-monitor-log.sh dvezzani@prodstorm0:/tmp/; ssh dvezzani@prodstorm0 '/tmp/scrape-lag-monitor-log.sh 2017-12-14'

hostid=$(hostname)
REPORT_DATE=$1

if [ "$REPORT_DATE" == '' ]; then
	REPORT_DATE=$(date -u +"%Y-%m-%d")
fi

ds="$REPORT_DATE"

ds2=$(date --date="$REPORT_DATE" "+%Y.%m.%d" 2> /dev/null)
if [ "$?" != '0' ]; then
	the_year=$(echo "$REPORT_DATE" | sed 's/\([^-]*\)-[^-]*-[^-]*$/\1/g');  #echo "$the_year"
	the_month=$(echo "$REPORT_DATE" | sed 's/[^-]*-\([^-]*\)-[^-]*$/\1/g'); #echo "$the_month"
	the_day=$(echo "$REPORT_DATE" | sed 's/[^-]*-[^-]*-\([^-]*\)$/\1/g');   #echo "$the_day"
	ds2=$(date -v"$the_year"y -v"$the_month"m -v"$the_day"d "+%Y.%m.%d")
fi
ds3=$(echo "$ds2" | sed 's/\.//g')

#src_filename="node-${ds2}.log"
src_filename="node-prodstorm0-${ds3}.log"
dst_filename="node-${hostid}-${ds}.json"

# rm "/tmp/${dst_filename}"

printf '[' > "/tmp/${dst_filename}"
# sudo sed 's/^\([^ ]*\) INFO *\([A-Z_]*\) *, *\([^ ]*\) *, *\([^ ]*\) *, *\([^ ]*\).*$/{\"date\":\"'$ds' \1 UTC\",\"source\":\"\2\",\"uuid\":\"\3\",\"callstatus\":\"\4\",\"userid\":\"\5\"}/g' "/var/log/storm/lag_monitor/${src_filename}" | tr '\n' ',' | sed 's/,*$/\]/g' >> "/tmp/${dst_filename}"
sudo sed 's/^\([^ ]*\) INFO *\([A-Z_]*\) *, *\([^ ]*\) *, *\([^ ]*\) *, *\([^ ]*\).*$/{\"date\":\"'$ds' \1 UTC\",\"source\":\"\2\",\"uuid\":\"\3\",\"callstatus\":\"\4\",\"userid\":\"\5\"}/g' "/tmp/${src_filename}" | tr '\n' ',' | sed 's/,*$/\]/g; s/,,*/,/g; ' >> "/tmp/${dst_filename}"
# less "/tmp/${dst_filename}"
echo "scp dvezzani@$(hostname):/tmp/${dst_filename} ."

