
disableScheduledTask() {
group=$1
task=$2
CMD=$(cat << EOL
curl 'https://l16275:8001/scheduled-task-enable.xqy?section=group&group=${group}&task=${task}&enabled=false' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \
  -H 'Authorization: Digest username="deployment", realm="Welfare_DEV", nonce="3bd0d1a5f24ba2:6y3wLHtH8eoKpmucabuQIA==", uri="/scheduled-task-enable.xqy?section=group&group=${group}&task=18155910695714736112&enabled=false", response="7584e4a099f48c2c5394e7ea03408a25", opaque="5fad26bc21ad3dde", qop=auth, nc=000005fa, cnonce="13c80e7faee5c99e"' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Referer: https://l16275:8001/scheduled-tasks-admin.xqy?section=group&group=${group}' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Google Chrome";v="113", "Chromium";v="113", "Not-A.Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  --compressed \
  --insecure

curl 'https://l16275:8001/scheduled-tasks-admin.xqy?section=group&group=${group}' \\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'Authorization: Digest username="deployment", realm="Welfare_DEV", nonce="3bd0d1a5f24ba2:6y3wLHtH8eoKpmucabuQIA==", uri="/scheduled-tasks-admin.xqy?section=group&group=${group}", response="d7f4027692b8f937135b81ca00a0b217", opaque="5fad26bc21ad3dde", qop=auth, nc=000005fb, cnonce="41c36b990b229fc0"' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://l16275:8001/scheduled-tasks-admin.xqy?section=group&group=${group}' \\
  -H 'Sec-Fetch-Dest: document' \\
  -H 'Sec-Fetch-Mode: navigate' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'Sec-Fetch-User: ?1' \\
  -H 'Upgrade-Insecure-Requests: 1' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' \\
  -H 'sec-ch-ua: "Google Chrome";v="113", "Chromium";v="113", "Not-A.Brand";v="24"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  --compressed \\
  --insecure  
EOL
)

eval "$CMD"
}
