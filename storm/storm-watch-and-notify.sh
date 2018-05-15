#!/bin/bash

# Usage: ~/scripts/storm-watch-and-notify.sh /Users/dcvezzani/greenseedtechnologies/storm-admin /home/ubuntu/src
# Usage (vim users): ~/scripts/storm-watch-and-notify.sh /Users/dcvezzani/greenseedtechnologies/storm-admin /home/ubuntu/src vim

if [ "$1" == "" ]; then
	echo Usage: ~/scripts/storm-watch-and-notify.sh /Users/dcvezzani/greenseedtechnologies/storm-admin /home/ubuntu/src
	echo "Usage (vim users): ~/scripts/storm-watch-and-notify.sh /Users/dcvezzani/greenseedtechnologies/storm-admin /home/ubuntu/src vim"
	exit 1
fi

local_path="$1"
remote_path="$2"
using_vim="$3"
declare -a MODIFIED_FILES

fswatch --event-flags -r "$local_path" | while read file event; do 
	#echo "filtering event: $event; $file; $using_vim"
	# echo "${!MODIFIED_FILES[@]}" 

	# filter files that have been edited by vim users
	# non-vim users won't need to check events
	filter01=$(if [[ "$file" =~ "\/\(\.[^\/\.]*\)*\.sw[a-z]?$" ]]; then echo '1'; else echo '0'; fi)
	filter03=$(if [ "$event" == "Created PlatformSpecific Renamed Updated OwnerModified IsFile" ]; then echo '1'; else echo '0'; fi)
	filters="${filter01}${filter03}"

	if ([ "$using_vim" != "" ] && [ "${filters}" == '01' ]) || [ "$using_vim" == "" ]; then

		# isolate path and file name that correspond with the VM path to the resource
		remote_filename=$(echo "$file" | sed 's#^'$local_path'##g')
		#echo "$file > $remote_filename (${MODIFIED_FILES[$(printf "$remote_filename" | sed 's#[^a-zA-Z0-9]#_#g')]})"

		# filter out notification from VM that the file was modified
		if [ "${MODIFIED_FILES[$(printf "$remote_filename" | sed 's#[^a-zA-Z0-9]#_#g')]}" == "1" ]; then
			MODIFIED_FILES[$(printf "$remote_filename" | sed 's#[^a-zA-Z0-9]#_#g')]=0

		# all we care about are changes to the file on the local, non-vm side
		elif [ "$remote_filename" != "" ]; then
			MODIFIED_FILES[$(printf "$remote_filename" | sed 's#[^a-zA-Z0-9]#_#g')]=1
			echo "touch ${remote_path}${remote_filename}"
			vagrant ssh -c "touch ${remote_path}${remote_filename}"
		fi
	fi
done


