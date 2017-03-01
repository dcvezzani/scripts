#!/bin/bash
/Users/davidvezzani/scripts/get-server-details-for-hypervisor.sh

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
source ~/.stackrc

if [ -z "$1" ]; then
  echo "Usage: . get-server-details-for-hypervisor.sh <hypervisor-name>; '. get-server-details-for-hypervisor.sh ds0143.sjc03.blueboxgrid.com'  The period is important in providing the environment for the commands to run."
  exit 1;
fi

hypervisor="$1"

while read server_id; do

  # server_id=8979764e-fd70-4e17-a36a-ede1fa581b81

  #| 43454cd4-73f9-491f-9f0b-ac244b3035a8 | core-app09        | ACTIVE | internal=192.168.1.123                |                                |
  server_metadata=($(openstack server list | grep -e "$server_id" | sed 's/| [^ ]* *| \([^ ]*\) *| [^ ]* *| [^=]*=\([^|]*\).*/\1 \2/g' | tr ',' ' '))

  server="${server_metadata[@]:0:1}"
  # server=$(nova show "$server_id" | grep -e '| name' | sed 's/| name *| \([^ ]*\).*/\1/g'); echo $server

  #| flavor                      | sl-app (a814a8e9-fdc8-4643-baa7-00a13b4ed414)            |
  flavor=$(openstack server show "$server" | grep -e '| flavor' | sed 's/| flavor *| \([^ ]*\).*/\1/g')

  echo "\nserver: $server"
  echo "id: $server_id"
  ip_address_list=$(echo "${server_metadata[@]:1}" | sed 's/ /, /g')
  echo "ip addresses: $ip_address_list"
  #for stat in $(openstack flavor show "$flavor" | grep -e '| disk' -e '| ram' -e '| vcpus'); do
  #  echo "$stat"
  #done

  #| disk                       | 40                                   |
  while read stat
  do
    echo "$stat"
  done <<< $(openstack flavor show "$flavor" | grep -e '| disk' -e '| ram' -e '| vcpus' | sed 's/| \([^ ]*\) *| \([^ ]*\).*/\1: \2/g')

  # | 43454cd4-73f9-491f-9f0b-ac244b3035a8 | instance-00000412 | 16            | ds0143.sjc03.blueboxgrid.com |
done <<< $(nova hypervisor-servers "$hypervisor" | grep -e '^| ' | grep -v '^| ID' | sed 's/^| \([^ ]*\).*/\1/g')

