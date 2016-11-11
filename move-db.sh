client_name=toylynx

echo "Go to maintenance mode"
if [ -e /home/deploy/core/current/frontend/public/themes/clients/${client_name}/maintenance.html ]; then
  echo "#> maintence is already on"
else
  echo "#> set maintenance mode"
  echo "sudo cp /srv/nfs/share/maintenance.html /srv/nfs/share/themes/clients/${client_name} && "
fi

echo -e "\n==== On crystal==== "
echo "mysql crystal -e \"call find_in_crystal('$client_name')\""

command='select * from \`databases\` where \`database\` = '"'"''${client_name}''"'"'; update \`databases\` set host_id=12 where \`database\` = '"'"''${client_name}''"'"' and host_id=2 limit 1;'
echo "#> change registry for client
echo "mysql -e \"${command}\" crystal"

echo -e "\n==== On ds1220 ==== \n"
#echo $(ssh ccadmin@208.85.150.99 "hostname >/dev/null 2>&1; echo $?")
echo "Creating dump..."
echo $(ssh ccadmin@208.85.150.99 "mysqldump --routines ${client_name} > ~/dumps/${client_name}.sql; echo $?")
dump_completed=$(echo $(ssh ccadmin@208.85.150.99 "tail -n 1 ~/dumps/${client_name}.sql | grep -q \"Dump completed on\""; echo $?))

if [ $dump_completed -gt 0 ]; then
  printf "NO"
  exit 1

else
  printf "YES"

  command='select * from \`databases\` where \`database\` = '"'"''${client_name}''"'"'; update \`databases\` set host_id=12 where \`database\` = '"'"''${client_name}''"'"' and host_id=2 limit 1;'

  command='mysql -e "drop database \`'${client_name}'\`;"'
  echo $command
  
  puts "\n==== On ds1402 ==== "

  command='mysql -e "create database \`'${client_name}'\`" && mysql  --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;" '${client_name}' < /srv/ice/share/backup/mysql/'${client_name}'.sql; if [ $? -gt 0 ]; then echo "Unable to create table"; fi'
  echo $command
  
  echo "Go to live mode"
  if [ -e /home/deploy/core/current/frontend/public/themes/clients/${client_name}/maintenance.html ]; then
    echo "#> remove maintenance mode"
    echo "sudo rm /srv/nfs/share/themes/clients/${client_name}/maintenance.html && "
  else
    echo "#> maintence is already off.  Really?"
  fi
    
fi
