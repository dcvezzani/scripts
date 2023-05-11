#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// From browser after creating a user session for the targeted FE application
// const CONNECT_SID="s:L4Ou1briCVGQ8tgWZzLpcZC_-KEMQRiv.SgNv67uofQTQ9RyC+sR7eeS5lthFH3uqelOPm7uDaR4"
const CONNECT_SID="s:o_cwe2kwGn6Y-upfoOYBRjbmeBz9tcph.78k5SJK6cMj2+CEQp+q6kq1e/5E4QcEvIf9y3Z1DN7A"

// From cf json config (i.e., credentials.auth.store.secret)
const SECRET = '08ec6a72-a957-4e3c-bafd-1e0c9493bf93'

// From cf json config (i.e., credentials.auth.store.hosts)
// const MEMCACHED_HOST = 'temples-blt-memcache-prod.apps.internal' 
const MEMCACHED_HOST = 'localhost' 

// cfcli app name
const APP_NAME = 'temples'


try {
  const connect_sid = CONNECT_SID.replace(/^s:/, '')
  const signature = require('cookie-signature')
  const result = signature.unsign(connect_sid, SECRET);

  console.log(`${result}

cfcli ${APP_NAME} prod fe ssh

HOST=${MEMCACHED_HOST}
printf "get sess:${result}\\r\\n" | nc "\$HOST" 11211
`)

} catch(err) {
  console.error(err)

  console.log(`
Get's memcached key value from connect.sid user session cookie.

Requirements
- cd to the directory of a FE application
- package.json must include 'cookie-signature'

E.g., 
~/scripts/get-session-cookie-value.js
`)
}
