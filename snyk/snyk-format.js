#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const fs = require('fs')

const lines = fs.readFileSync('./snyk.txt').toString().trim().split("\n").filter(entry => entry.length > 0)

process.stdout.write(`[${lines.join(",\n")}]`)

/*

/Users/dcvezzani/projects/recovery-fe/scripts/snyk-format.js | jq '. | sort_by(.percentage)'

/Users/dcvezzani/projects/recovery-fe/scripts/snyk-format.js | jq '. | sort_by(.percentage) | map({name, percentage, scores: (.scores | map(select(.status == "danger")))}) | map(select((.scores | length) > 0))'

 */
