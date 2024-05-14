#!/Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const RE = {
  pipeChar: /\|/, 
  serializedNewline: /\n/,
  serializedTab: /\t/g,
  columnLineBreak: / *\/\/ *| *<br\/>\(- +\)*/g,
  variableDefinition: /^\$([^=]+)=(.*)$/,
  variableReference: /\$\{([^\}]+)\}/,
  defaultColumnSeparator: /\s*,\s*/,
  anythingExceptPipe: /[^|]/g,
  headerDivider: /^[,-]+$/,
  justCommas: /^,+$/,
  explicitComma: /,/g,
  commaPlaceholder: /__comma__/g,
}

const state = {
  lines: [],
  variables: {},
  columnDivider: RE.defaultColumnSeparator,
  columnLineBreak: RE.linkBreak,
  columnWidths: [],
  re: {},
  commaPlaceholder: '__comma__',
  escapedComma: "','",
}

const parseVariableDefinition = (line) => {
  let [_, name, value] = line.match(RE.variableDefinition) || []
  // if (RE.variableReference.test(value)) value = transformResolveVariables(value)
  return {name, value}
}

const serializeVariables = () => {
  return Object.entries(state.variables).map(([key, value]) => {
    return `$${key}=${value}` 
  }).join("\n")
}

// const split = require('split');
// const input = process.stdin.pipe(split());
// const output = process.stdout;

const reduce = (line) => {
  if (line.startsWith('$')) {
    const prop = parseVariableDefinition(line)
    state.variables[prop.name] = prop.value
    return
  }
  
  if ((line || '').trim().length === 0) return

  line = line.replaceAll(RE.explicitComma, state.escapedComma)

  let newLine = line.replaceAll(/ *\| */g, ',')
  .replace(/^,/, '')
  .replace(/,$/, '')

  if (RE.headerDivider.test(newLine) && !RE.justCommas.test(newLine)) return

  newLine = Object.keys(state.variables).reduce((line, key) => {
    let value = state.variables[key]

    if (!(key in state.re)) {
      value = value.replaceAll(/([\$\/\{\}])/g, "\\$1")
      state.re[key] = new RegExp(value, 'g')
    }

    return line.replaceAll(state.re[key], '${' + key + '}')
  }, newLine)

  state.lines.push(newLine)
}


// input.on('data', line => {
//   reduce(line)
// });

// input.on('end', () => {
//   console.log(serializeVariables())
//   console.log()
//   console.log(state.lines.join("\n"))
// });

// input.on('error', e => {
//   console.error(e)
// });

const lines = (process.argv[2] || '').trim().split("\n")

lines.forEach(line => reduce(line))

// process.stderr.write(`Variables: \n${JSON.stringify(state.variables, null, 2)}\n\n`)

console.log(serializeVariables())
console.log()
console.log(state.lines.join("\n"))

/*
*/

/*

cat << 'EOL' | /Users/dcvezzani/scripts/serialize-md-table.js
$Ne=Node Express
$RNxNe=React/Next.js/${Ne}
$ML=Marklogic
$JSB=Java Spring Boot
$PH=PubHub
$An=AngularJS

| application                           | stack                      |                               |            | platform | cms engine                 |
|---------------------------------------|----------------------------|-------------------------------|------------|----------|----------------------------|
|                                       | fe                         | ws                            | cms        |          |                            |
|                                       |                            |                               |            |          |                            |
| ARP - Addiction Recovery Program      | React/Next.js/Node Express | Node Express(AWS Fargate/RDS) | Marklogic  |          | PubHub                     |
| Church History Record Keeping Website | React/Next.js/Node Express |                               | Marklogic  |          | PubHub                     |
| Church History Specialist             | React/Next.js/Node Express | Java Spring Boot              | Marklogic  |          | PubHub                     |
| Deseret Industries                    | React/Next.js/Node Express |                               | Marklogic  |          | PubHub                     |
| Deseret Trust                         | React/Next.js/Node Express | Node Express                  | Brightspot | DOZR     | Content Delivery API (CDA) |
| Missionary Planning                   | React/Next.js/Node Express | Java Spring Boot              | Marklogic  |          | PubHub                     |
| Missionary Referral                   | React/Next.js/Node Express | Java Spring Boot              | Marklogic  |          | PubHub                     |
| Provident Living                      | AngularJS                  |                               | Marklogic  |          | Publisher (ICE)            |
| SI Public Sites                       | React/Next.js/Node Express | Node Express                  | Marklogic  |          | PubHub                     |
| Temple Web                            | React/Next.js/Node Express | Node Express                  | Marklogic  |          | PubHub                     |
| Thrasher Website                      | React/Next.js/Node Express | Java Spring Boot              | Marklogic  |          | PubHub                     |
EOL

*/
