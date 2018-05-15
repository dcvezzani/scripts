#!/bin/bash

# /Users/dcvezzani/scripts/build-delay-report.sh prodstorm0 &; /Users/dcvezzani/scripts/build-delay-report.sh prodstorm1 &

hostid=$1
report_attempts=$2

if [ "$REPORT_DATE" == '' ]; then
	REPORT_DATE=$(date -u +"%Y-%m-%d")
fi

year_month_day_dash="$REPORT_DATE"
ds=$(echo "$year_month_day_dash" | sed 's/-//g')
year_month_day=$(echo "$year_month_day_dash" | sed 's/-/_/g') #; echo "$year_month_day"

# ds=$(date -u +"%Y%m%d")
# year_month_day=$(date -u +"%Y_%m_%d")
# echo "$year_month_day_dash, $ds, $year_month_day"

if [ "$report_attempts" == '' ]; then
  rm /Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*
  rm /Users/dcvezzani/lightstreamer-${hostid}-report-by-target-${year_month_day}T

	# remote

	# hostid=prodstorm0 REPORT_DATE=2017-12-14 
	scp /Users/dcvezzani/scripts/scrape-storm-log-files.sh "dvezzani@${hostid}:/tmp" && ssh -t "dvezzani@${hostid}" "sudo /tmp/scrape-storm-log-files.sh $REPORT_DATE"
	# scp /Users/dcvezzani/scripts/scrape-lag-monitor-log.sh "dvezzani@${hostid}:/tmp" && ssh -t "dvezzani@${hostid}" "sudo /tmp/scrape-lag-monitor-log.sh $REPORT_DATE"

	# local

	printf "\nFetching log files for Freeswitch, Lighstreamer and Node from ${hostid} for ${ds}\n"
	scp dvezzani@${hostid}:/tmp/fs-${hostid}-${ds}.log .
	scp dvezzani@${hostid}:/tmp/ls-${hostid}-${ds}.log .
	scp dvezzani@${hostid}:/tmp/node-${hostid}-${ds}.log .
	# scp dvezzani@${hostid}:/tmp/node-${hostid}-${ds}.json .

	if [ ! -e "./storm-reports-archive" ]; then
		mkdir -p ./storm-reports-archive
	fi

	mv /Users/dcvezzani/*-${hostid}-report-by-target-${year_month_day}T*.* ./storm-reports-archive

	printf "\nCreating reports for Freeswitch: /Users/dcvezzani/fs-${hostid}-${ds}.log\n"
	ruby ~/Documents/journal/current/20171115-generate-freeswitch-reports.rb ${hostid} /Users/dcvezzani/fs-${hostid}-${ds}.log &

	printf "Creating reports for Lightstreamer: /Users/dcvezzani/ls-${hostid}-${ds}.log\n"
	ruby ~/Documents/journal/current/20171115-generate-lighstreamer-reports.rb ${hostid} /Users/dcvezzani/ls-${hostid}-${ds}.log &

	printf "Creating reports for Node: /Users/dcvezzani/node-${hostid}-${ds}.log\n\n"
	ruby ~/Documents/journal/current/20171115-generate-node-reports.rb ${hostid} /Users/dcvezzani/node-${hostid}-${ds}.log &

fi 

json_content_fs=$(bash -c "ls /Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*.json 2> /dev/null" | tail -n1)
json_content_ls=$(bash -c "ls /Users/dcvezzani/lightstreamer-${hostid}-report-by-target-${year_month_day}T*.json 2> /dev/null" | tail -n1)
json_content_node=$(bash -c "ls /Users/dcvezzani/node-${hostid}-report-by-target-${year_month_day}T*.json 2> /dev/null" | tail -n1)
json_content=$(echo "$json_content_fs $json_content_ls"); echo "$json_content"

json_fs_node_content=$(echo "$json_content_fs $json_content_node"); echo "$json_fs_node_content"

json_content_fs_done=$(bash -c "ls -tr /Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*.txt.done.txt 2> /dev/null" | tail -n1)
json_content_ls_done=$(bash -c "ls /Users/dcvezzani/lightstreamer-${hostid}-report-by-target-${year_month_day}T*.txt.done.txt 2> /dev/null" | tail -n1)
json_content_node_done=$(bash -c "ls /Users/dcvezzani/node-${hostid}-report-by-target-${year_month_day}T*.txt.done.txt 2> /dev/null" | tail -n1)
json_content_done=$(echo "$json_content_fs_done $json_content_ls_done $json_content_node_done"); echo "$json_content_done"

if [ "$(echo $json_content_done | wc -w | xargs)" == '3' ]; then

  txt_content_fs=$(bash -c "ls /Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*.txt 2> /dev/null" | sed '/compressed/d; /done/d' | tail -n1) #; echo "'$txt_content_fs'"
  txt_content_ls=$(bash -c "ls /Users/dcvezzani/lightstreamer-${hostid}-report-by-target-${year_month_day}T*.txt 2> /dev/null" | sed '/compressed/d; /done/d' | tail -n1) #; echo "'$txt_content_ls'"
  txt_content_node=$(bash -c "ls /Users/dcvezzani/node-${hostid}-report-by-target-${year_month_day}T*.txt 2> /dev/null" | sed '/compressed/d; /done/d' | tail -n1) #; echo "'$txt_content_node'"

	fs_call_count=$(sed '/total phone calls made/!d; s/^\([^ ]*\) total phone calls made/\1/g' $txt_content_fs | xargs) #; echo $fs_call_count
	ls_call_count=$(sed '/total phone calls made/!d; s/^\([^ ]*\) total phone calls made/\1/g' $txt_content_ls | xargs) #; echo $ls_call_count
	node_call_count=$(sed '/total phone calls made/!d; s/^\([^ ]*\) total phone calls made/\1/g' $txt_content_node | xargs) #; echo $node_call_count
	
	fs_event_count=$(sed '/total events processed/!d; s/^\([^ ]*\) total events processed/\1/g' $txt_content_fs | xargs) #; echo $fs_event_count
	ls_event_count=$(sed '/total events processed/!d; s/^\([^ ]*\) total events processed/\1/g' $txt_content_ls | xargs) #; echo $ls_event_count
	node_event_count=$(sed '/total events processed/!d; s/^\([^ ]*\) total events processed/\1/g' $txt_content_node | xargs) #; echo $node_event_count
	
	data='{\"data\":{\"calls-count\":{\"fs\":\"'$fs_call_count'\",\"ls\":\"'$ls_call_count'\",\"node\":\"'$node_call_count'\"},\"events-count\":{\"fs\":\"'$fs_event_count'\",\"ls\":\"'$ls_event_count'\",\"node\":\"'$node_event_count'\"}}}' #; printf "\nData: $data\n\n"

	# generate and open delay report for fs/ls
	printf "\nCreating delay report: /Users/dcvezzani/fs-ls-delay-report-summary-${hostid}-${ds}.txt\n"
	printf "  Using '${json_content}' as input\n\n"

	ruby /Users/dcvezzani/Documents/journal/current/20171204-fs-ls-delay-report.rb $(echo "$hostid ${json_content} $data" | xargs)
	sed -i'' -e 's#cdate=\(.\)[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.*$#cdate=\"'"$year_month_day_dash"'\"#g' /Users/dcvezzani/scripts/finalize-storm-log-report.xvim
	mvim -c 'source /Users/dcvezzani/scripts/finalize-storm-log-report.xvim' /Users/dcvezzani/fs-ls-delay-report-summary-${hostid}-${ds}.txt 2> /dev/null
	
	if [ "$?" != "0" ]; then
		printf "Report finished - FS/Node delay report: /Users/dcvezzani/fs-node-delay-report-summary-${hostid}-${ds}.txt"
	fi
	
	# generate and open delay report for fs/node
	printf "\nCreating delay report: /Users/dcvezzani/fs-node-delay-report-summary-${hostid}-${ds}.txt\n"
	printf "  Using '${json_content}' as input\n\n"
	
	ruby /Users/dcvezzani/Documents/journal/current/20171204-fs-node-delay-report.rb $(echo "$hostid ${json_fs_node_content} $data" | xargs)
	mvim -c 'source /Users/dcvezzani/scripts/finalize-storm-log-report.xvim' /Users/dcvezzani/fs-node-delay-report-summary-${hostid}-${ds}.txt 2> /dev/null

	# # open individual reports
	# for file in "/Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*.txt" "/Users/dcvezzani/lightstreamer-${hostid}-report-by-target-${year_month_day}T*.txt" "/Users/dcvezzani/node-${hostid}-report-by-target-${year_month_day}T*.txt"; do
	# 	mvim "$file"
	# done

	# generate graphs
	chart_tempate_filename="/Users/dcvezzani/Documents/journal/05-may-2017/20171214-charts-delay-count.html"
	html_filename="/Users/dcvezzani/charts-${hostid}-delay-count-${year_month_day}.html"

	fs_call_count=$(printf "${data}" | jq -r '.data["calls-count"].fs') #; echo "$fs_call_count"
	ls_call_count=$(printf "${data}" | jq -r '.data["calls-count"].ls') #; echo "$ls_call_count"
	node_call_count=$(printf "${data}" | jq -r '.data["calls-count"].node') #; echo "$node_call_count"

	fs_event_count=$(printf "${data}" | jq -r '.data["events-count"].fs') #; echo "$fs_event_count"
	ls_event_count=$(printf "${data}" | jq -r '.data["events-count"].ls') #; echo "$ls_event_count"
	node_event_count=$(printf "${data}" | jq -r '.data["events-count"].node') #; echo "$node_event_count"

	cat ${chart_tempate_filename} | sed 's/__date__/'${year_month_day_dash}'/g; s/__hostid__/'${hostid}'/g; s/__fs_call_count__/'${fs_call_count}'/g; s/__ls_call_count__/'${ls_call_count}'/g; s/__node_call_count__/'${node_call_count}'/g; s/__fs_event_count__/'${fs_event_count}'/g; s/__ls_event_count__/'${ls_event_count}'/g; s/__node_event_count__/'${node_event_count}'/g' > ${html_filename}
	
	# year_month_day_dash=2017-12-19 hostid=prodstorm3 && cat /Users/dcvezzani/Documents/journal/05-may-2017/20171214-charts-delay-count.html | sed 's/__date__/'${year_month_day_dash}'/g; s/__hostid__/'${hostid}'/g; s/__fs_call_count__/${fs_call_count}/g; s/__ls_call_count__/${ls_call_count}/g; s/__node_call_count__/${node_call_count}/g; s/__fs_event_count__/${fs_event_count}/g; s/__ls_event_count__/${ls_event_count}/g; s/__node_event_count__/${node_event_count}/g' > /Users/dcvezzani/charts-${hostid}-delay-count-${year_month_day_dash}.html; echo /Users/dcvezzani/charts-${hostid}-delay-count-${year_month_day_dash}.html

	ruby /Users/dcvezzani/scripts/create-event-graph.rb "/Users/dcvezzani/freeswitch-${hostid}-report-by-target-${year_month_day}T*.json" "$year_month_day_dash" "$html_filename"
	ruby /Users/dcvezzani/scripts/create-delay-graph.rb "./fs-ls-delay-report-${hostid}-${ds}.json" "$year_month_day_dash" "$html_filename"
	# ruby /Users/dcvezzani/scripts/create-delay-graph.rb "./fs-node-delay-report-${hostid}-${ds}.json" "$year_month_day_dash" "$html_filename"
	open ${html_filename}

	if [ "$?" != "0" ]; then
		printf "Report finished - FS/Node delay report: /Users/dcvezzani/fs-node-delay-report-summary-${hostid}-${ds}.txt"
	fi

	printf "\nDone!\n\n"

else
	if [ "$report_attempts" == '' ]; then
		report_attempts=1
	else
		if [ "$report_attempts" -gt 9 ]; then
			printf "\nReport attempt timed out ($report_attempts attempts were made).  Aborting request for delay report.\n\n"
			exit 1
		else
			report_attempts=$((report_attempts + 1))
		fi
	fi

	printf "\nStill waiting for data files before generating delay report.  Will try again in a little bit ($report_attempts attempts so far)...\n"
	sleep 30
	/Users/dcvezzani/scripts/build-delay-report.sh $hostid "$report_attempts" &
	printf "poll pid: $!\n\n"

fi
