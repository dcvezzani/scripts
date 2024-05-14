#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const formatTags = (data) => {
  const entry = JSON.parse(data)
  const tags = []
  if (entry.parent) tags.push(entry.parent)
  if (entry.name) tags.push(`${entry.name}:${entry.offset}`)
  // if (entry.offset) tags.push(`trace ${entry.line}`)
  return tags.join(', ')
}

// const split = require('split');
// const input = process.stdin.pipe(split());
// const input = process.stdin;
// const output = process.stdout;

const state = {data: ''}

async function main() {
  for await (const chunk of process.stdin) state.data += chunk;

  const payload = formatTags(state.data.toString())
  
  // process all the data and write it back to stdout
  // process.stdout.write(JSON.stringify(state.data, null, 2));
  process.stdout.write(payload);
}

main();


