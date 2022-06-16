#!/bin/bash

cookie=

# =======================
function loadCookies() {
echo "loading cookies"

# lines=$(cat cookie.txt | perl -p -e 's# #\n#g' | grep 'ChurchSSO\|Church-auth-jwt-prod\|directory_access_token\|directory_refresh_token')
cookie=$(cat /Users/dcvezzani/.git/cookie | grep -i 'cookie')
}

# =======================
function get_prs() {
  cmd=$(cat << EOL
curl 'https://github.com/search?q=is%3Aopen+is%3Apr+user%3AICSEng+involves%3Aadamandreason+involves%3Adcvezzani-church+involves%3Ajtthor+involves%3Atberbert+created%3A%3E2022-01-01' \
  -H 'authority: github.com' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Google Chrome";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: none' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'accept-language: en-US,en;q=0.9' \
$cookie
  --compressed
EOL
)

  if [ "$DRYRUN" = "y" ]; then
    echo "DRYRUN"
    echo "$cmd"
  else
    eval "$cmd"
  fi
}
