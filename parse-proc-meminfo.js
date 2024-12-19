#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  // dataRaw: /^ +--data-raw \$*'(.+)'$/,
  // wwwFormUrlEncoded: /application\/x-www-form-urlencoded/,
  // contentType: /^ *-H 'Content-Type: /,
  // summary: /^## (.*)/,
  empty: /^$/,
  // acceptanceCriteria: /^### Acceptance criteria/,
  // table: /^\|/,
  statistic: /^([^:]+): +(.*)/,
  numberOnly: /^([^ ]+) .+/,
}

const state = {
  lines: []
}

input.on('data', line => {
  if (!RE.empty.test(line)) {
    const [ noop, key, value ] = line.match(RE.statistic) || []
    
    const numberInKbsStr = (value.match(RE.numberOnly) || [0])[1]
    let numberInKbs = parseFloat(numberInKbsStr)

    let numberInMbs, numberInGbs
    if (!numberInKbs.isNaN) {
      numberInMbs = numberInKbs / Math.pow(1024,1)
      numberInGbs = numberInKbs / Math.pow(1024,2)
    }

    if (['MemTotal', 'MemFree', 'MemAvailable'].includes(key)) state.lines.push({name: key, value, mbytes: numberInMbs.toFixed(2), gbytes: numberInGbs.toFixed(2)})
  }
});

input.on('end', async () => {
  console.log(JSON.stringify(state.lines))
});

input.on('error', error => {
  console.error('Error', error)
})

