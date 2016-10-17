#!/bin/zsh
# https://github.com/crystalcommerce/core/wiki/Using-Curl-To-Check-For-Rogue-Server

if [ $# -eq 0 ]
  then
    echo "Usage: ~/scripts/check-domain-for-app-hosts.sh wiiplaygames-pos.crystalcommerce.com"
    exit 1
fi

host_domain="$1"
# host_domain="wiiplaygames-pos.crystalcommerce.com"
dbclient=$(echo "$host_domain" |  sed 's/^\([^-\.]*\)[-\.]\([^\.]*\).*/\1/g')
core_type=$(echo "$host_domain" | sed 's/^\([^-\.]*\)[-\.]\([^\.]*\).*/\2/g')
host_prefix="cloud-app"
idx=02
url_path=''
forward_proto=''

# search string that indicates success
case $core_type in
  'pos')
    forward_proto="-H 'X-Forwarded-Proto: https'"
    url_path=''
    success_check='\"current_client\":\"'$dbclient'\"'
    ;;
  'admin')
    forward_proto="-H 'X-Forwarded-Proto: https'"
    url_path='dashboard/feed?feed%5Bcount%5D=5&feed%5Bpage%5D=1'
    success_check='Logged in as crystal'
    ;;
  *)
    success_check='content=\"CrystalCommerce\"'
    ;;
esac

admin_cookie='Cookie: __utma=250373076.1300562637.1461763376.1476470590.1476475023.99; __utmz=250373076.1470961799.79.8.utmcsr=hive.crystalcommerce.com|utmccn=(referral)|utmcmd=referral|utmcct=/clients/8893; __gads=ID=096639c742e08f27:T=1461764317:S=ALNI_MZHdYey6SGAfL6L1kpmmrXHI9w-Mg; _ga=GA1.2.1300562637.1461763376; __utmc=250373076; _admin_session=08d0c7a08c81b5b200035915823e44bb; __utmb=250373076.1.10.1476475023; __utmt=1; liveagent_oref=; liveagent_vc=2; liveagent_sid=7269fc67-5db3-48ab-9a62-3e8a596e00dd; liveagent_ptid=7269fc67-5db3-48ab-9a62-3e8a596e00dd'

pos_cookie='Cookie: __utma=250373076.1300562637.1461763376.1476470590.1476475023.99; __utmz=250373076.1470961799.79.8.utmcsr=hive.crystalcommerce.com|utmccn=(referral)|utmcmd=referral|utmcct=/clients/8893; __gads=ID=096639c742e08f27:T=1461764317:S=ALNI_MZHdYey6SGAfL6L1kpmmrXHI9w-Mg; _ga=GA1.2.1300562637.1461763376; _point_of_sale_session=70d66a59b19501a070e016d20f452a12; __utmc=250373076; __utmb=250373076.5.10.1476475023'

frontend_cookie='Cookie: __utma=250373076.1300562637.1461763376.1476470590.1476475023.99; __utmz=250373076.1470961799.79.8.utmcsr=hive.crystalcommerce.com|utmccn=(referral)|utmcmd=referral|utmcct=/clients/8893; __gads=ID=096639c742e08f27:T=1461764317:S=ALNI_MZHdYey6SGAfL6L1kpmmrXHI9w-Mg; _ga=GA1.2.1300562637.1461763376; __utmc=250373076; __utmb=250373076.5.10.1476475023; _insecure_frontend_session_id=e82fb70cd398e9cc2fb91a02daecf2f3; __utma=67038140.1300562637.1461763376.1476477534.1476477534.1; __utmb=67038140.1.10.1476477534; __utmc=67038140; __utmz=67038140.1476477534.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt=1'

sessions_cookie='Cookie: __utma=250373076.1300562637.1461763376.1476470590.1476475023.99; __utmz=250373076.1470961799.79.8.utmcsr=hive.crystalcommerce.com|utmccn=(referral)|utmcmd=referral|utmcct=/clients/8893; __gads=ID=096639c742e08f27:T=1461764317:S=ALNI_MZHdYey6SGAfL6L1kpmmrXHI9w-Mg; _ga=GA1.2.1300562637.1461763376; _admin_session=08d0c7a08c81b5b200035915823e44bb; _point_of_sale_session=70d66a59b19501a070e016d20f452a12; _insecure_frontend_session_id=e82fb70cd398e9cc2fb91a02daecf2f3; __utmc=250373076; __utmb=250373076.5.10.1476475023'

sessions_cookie='Cookie: __utma=250373076.1300562637.1461763376.1476540144.1476623175.104; __utmz=250373076.1470961799.79.8.utmcsr=hive.crystalcommerce.com|utmccn=(referral)|utmcmd=referral|utmcct=/clients/8893; __gads=ID=096639c742e08f27:T=1461764317:S=ALNI_MZHdYey6SGAfL6L1kpmmrXHI9w-Mg; _ga=GA1.2.1300562637.1461763376; _point_of_sale_session=01ce1216e3d16f8d9a1c6b30b21b373c; _admin_session=8f7b9e7fdd2db667a9c502838284240d; _insecure_frontend_session_id=508aef6852461fb5a4c5484a109040de'

cookie=$frontend_cookie
cookie=$sessions_cookie

prefix="$host_prefix-$dbclient-$core_type-$(date +%Y%m%s%H%M%S)"

echo "" > $prefix.txt
for idx in 01 02 03 04 05 06 07 08 09 10 11; do
  echo "# === $host_prefix$idx ==================" >> $prefix.txt
  # res=$(echo "curl 'http://127.0.0.1/$url_path' \
  res=$(ssh $host_prefix$idx "curl 'http://127.0.0.1/$url_path' \
  $forward_proto \
  -H 'Host: $host_domain' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:49.0) Gecko/20100101 Firefox/49.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H '$cookie' \
  -H 'Connection: keep-alive' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Cache-Control: max-age=0' 2>&1 | \
  grep '$success_check' | \
  sed 's/.*\($success_check\).*/\1/g'")

  # echo $res
  # echo "$host_prefix$idx; $host_domain: $res"
  echo "$host_prefix$idx; $res"
  echo $res >> $prefix.txt
  echo -e "\n\n" >> $prefix.txt
done
