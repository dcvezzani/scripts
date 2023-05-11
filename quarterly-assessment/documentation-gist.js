#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

let lines = []
const reduce = (line) => {
  if (line.length > 0) {
    const [uuid, title, fileCount, scope, dateString] = line.split(/\t/)
    
    lines.push({uuid, title, fileCount, scope, dateString})
  }
}


input.on('data', line => {
  reduce(line)
});

input.on('end', () => {
  console.log(JSON.stringify(lines))
});

input.on('error', e => {
  console.error(e)
});

