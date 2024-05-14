#!/Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

// const split = require('split');
// const input = process.stdin.pipe(split());
// const output = process.stdout;

// const RE = {
//   variableDefinition: /^\$([^=]+)=(.*)$/,
//   variableReference: /\$\{([^\}]+)\}/,
//   defaultColumnSeparator: /\s*,\s*/,
//   columnLineBreak: / *\/\/ *| *<br\/>\(- +\)*/g,
//   anythingExceptPipe: /[^|]/g,
// }

const state = {
  lines: [],
  // variables: {},
  // originalVariables: {},
  // columnDivider: RE.defaultColumnSeparator,
  // columnLineBreak: RE.linkBreak,
  // columnWidths: [],
}

const reduce = (line) => {
  let newLine = line.replace(/^#+ */, '')
  let [_, label] = newLine.match(/^([^;]+)/)

  const bookmark = newLine.replaceAll(/[\/]/g, '')
    .replaceAll(/[^a-zA-Z0-9]+/g, '-')
  state.lines.push(`[${label}](#${bookmark})`)
}

// input.on('data', line => {
//   reduce(line)
// });

// input.on('end', () => {
//   console.log(state.lines.join("\n"))
// });

// input.on('error', e => {
//   console.error(e)
// });

const lines = (process.argv[2] || '').trim().split("\n")

lines.forEach(line => reduce(line))

// process.stderr.write(`Variables: \n${JSON.stringify(state.variables, null, 2)}\n\n`)

console.log(state.lines.join("\n"))


/*
cat << 'EOL' | ~/scripts/create-bookmark-ref.js
#### 📊 fig 2; apply custom column divider
EOL

*/
