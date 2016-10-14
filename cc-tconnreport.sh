#!/bash/bin

# Usage: tconnreport 2>&1 | tee tconnreport-$(date +%Y%m%d)-$(date +%H%M%S).txt
# Run from local dev environment

tconncheck ()
{
  atlabel=$1
  atcheck=$2
  tlabel=$(echo -e "$atlabel:\c")

  tresult=$(( eval $atcheck ) 2>&1)
  tstatus=$(if [ $? -eq 0 ]; then echo "success"; else echo "FAILED ($tresult)"; fi)
  res="$(printf "%-15s" "$tlabel")$tstatus"

  echo "  $res"
  errorstatus=$(echo "$res" | sed -rn 's/.* (FAILED) .*/\1/p')

  if [ "$errorstatus" == "FAILED" ]; then
    return 1
  fi
}

tconnchecksshport ()
{
  dbipaddr=$1
  res=$(tconncheck "port 22" "nc -w 1 $dbipaddr 22")

  if [ ! $? -eq 0 ]; then
    echo "$res"
    return 1
  else
    echo "$res"
  fi
}

tconncheckmysql ()
{
  dbipaddr=$1

  for mysqlport in 3306 3307; do
    error_cnt=0

    res=$(tconncheck "port $mysqlport" "nc -w 1 $dbipaddr $mysqlport"); if [ ! $? -eq 0 ]; then error_cnt=$[error_cnt+1]; fi; echo "$res"

    if [ $error_cnt -eq 0 ]; then
      res=$(tconncheck "mysql connect" "mysql --defaults-file=~/.my-crystal.cnf -Ns -h $dbipaddr -u crystal -P $mysqlport -e \"show databases\" crystal"); echo "$res"

    #else
    #  res="$(printf "%-15s" "mysql connect:")FAILED"; echo "  $res"
    fi
  done
}

tconncheckssh ()
{
  user=$1
  dbipaddr=$2

  for user in ccadmin deploy ubuntu; do
    res=$(tconncheck "ssh ($user)" "ssh -oBatchMode=yes $user@$dbipaddr 'hostname'")
    echo "$res"
  done
}

tconnreport ()
{
for dbhost in ds1401:169.44.133.54 ds1400:169.44.133.53 ds1331:169.44.133.51 db-m01:173.247.107.175 ds1220:208.85.150.99 ds1221:208.85.150.90 ds1224:208.85.150.68 ds1225:208.85.150.91 ds1223:208.85.150.126 ds1222:208.85.150.107; do

  #dbhost=ds1222:208.85.150.107
  dbhostname=$(echo "${dbhost%%:*}")
  dbipaddr=$(echo "${dbhost##*:}")
  error_cnt=0

  echo -e "Testing mysql connection for ${dbhostname} (${dbipaddr}): "

  tconnchecksshport $dbipaddr

  if [ ! $? -eq 0 ]; then
    msg="Unable to access"
    echo "$(printf "  %$[15 + ${#msg}]s" "$msg")"

  else
    tconncheckssh $user $dbipaddr
  fi

  tconncheckmysql $dbipaddr

  echo ""
  
done
}

tconnreport 2>&1 | tee tconnreport-$(date +%Y%m%d)-$(date +%H%M%S).txt
