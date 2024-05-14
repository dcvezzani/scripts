#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const line = parseInt(process.argv[2])

if (isNaN(line)) throw `Line number required`

const identifyCodeBlock = (data) => {
  const entries = JSON.parse(data)
  return entries.find(entry => entry.start <= line && line <= entry.end) || {}
}

const split = require('split');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {data: ''}

async function main() {
  for await (const chunk of process.stdin) state.data += chunk;

  const payload = identifyCodeBlock(state.data.toString(), line)

  if (typeof payload?.start === 'number') {
    payload.offset = line - payload.start
  }

  payload.line = line + 1
  
  // process all the data and write it back to stdout
  // process.stdout.write(JSON.stringify(state.data, null, 2));
  process.stdout.write(JSON.stringify(payload, null, 2));
}

main();

