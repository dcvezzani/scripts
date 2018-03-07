#!/bin/bash

# monitorhost="$1"; scp -r ~/monitor/scripts dvezzani@$monitorhost:; ssh dvezzani@$monitorhost '~/scripts/service_report.sh'

# monitorhost="$1"; scp -r ~/monitor/scripts dvezzani@$monitorhost: &> /dev/null; ssh dvezzani@$monitorhost '~/scripts/service_report.sh' | sed 's/'$(echo "\\033")'//g' | jq . > chk.json
# monitorhost="$1"; scp -r ~/monitor/scripts dvezzani@$monitorhost: &> /dev/null; ssh dvezzani@$monitorhost '~/scripts/service_report.sh' | sed 's/[^[:print:]\n]//g' | jq .

printf 'export default {"storm": {' > data.js
for monitorhost in "$@"; do
	echo "fetching status for $monitorhost"
	scp -r ~/monitor/scripts dvezzani@$monitorhost: &> /dev/null; 
	# json=$(ssh dvezzani@$monitorhost "~/scripts/service_report.sh $monitorhost" | sed 's/[^[:print:]\n]//g') 
	json=$(ssh dvezzani@$monitorhost "~/scripts/service_report.sh $monitorhost") 
	# echo "export default $json" > "data-$1.js"
	printf "{$json}" > "data-$1.js"
	printf "$json," >> "data.js"
done

printf '}}' >> data.js




