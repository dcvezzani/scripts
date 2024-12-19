#!/bash/bin

# =======================================
function mc_get_access_token() {
  sessionId="$1"

usage=$(cat << EOL
Usage: cftarget <app> <lane> <tier> | get_access_token <session-id>
EOL
)

if [ -z "$sessionId" ]; then
echo -e "$usage"
return
fi
  
  read json
  local target=$(echo "$json" | jq -r '.target')
  # local lane=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.lane')
  # local tier=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.tier')
  # local memcached=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.'"$tier"'.memached')

  local memcached=$(echo "$json" | jq -r '.memcached')

CMD=$(cat << EOL
HOST=$memcached.apps.internal
printf "get sess:${sessionId}\r\n" | nc -N "\$HOST" 11211
EOL
)

  local accessToken=$(cf ssh $target -c "$CMD" | grep -E '^\{' | jq -r '.passport.user.tokenset.access_token')
  echo "$accessToken" | perl -p -e 's/[\r\n]+//g' | pbcopy

cat << EOL
accessToken (copied to clipboard):
=================================
$accessToken
=================================
EOL
}

# =======================================
function mc_get_session_keys() {
  help="$1"

usage=$(cat << EOL
Usage: cftarget <app> <lane> <tier> | mc_get_session_keys
EOL
)

if [ ! -z "$help" ]; then
echo -e "$usage"
return
fi
  
  read json
  local target=$(echo "$json" | jq -r '.target')
  local memcached=$(echo "$json" | jq -r '.memcached')

CMD=$(cat << EOL
HOST=$memcached.apps.internal
printf "set mykey 0 100 4\r\ndata\r\n" | nc -N "\$HOST" 11211
printf "lru_crawler metadump all\r\n" | nc -N "\$HOST" 11211 | grep -E '^key=sess%3A'
EOL
)

cat << EOL
keys
=================================
$(cf ssh $target -c "$CMD")
=================================
EOL
}

# =======================================
cat << EOL
The following functions have been loaded (uses cfcli)

Function: mc_get_access_token
$(mc_get_access_token)

Function: mc_get_session_keys
$(mc_get_session_keys help)
EOL

