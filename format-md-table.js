#!/Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

// console.log(process.argv)


const RE = {
  pipeChar: /\|/, 
  serializedNewline: /\n/,
  serializedTab: /\t/g,
  columnLineBreak: / *\/\/ *| *<br\/>\(- +\)*/g,
}

const lines = (process.argv[2] || '').trim().split("\n")

// const lines = ('| Resource                                | ave res time | focus |\n' + 
//   '|-----------------------------------------|------------|---------|\n' +
//   '| /temples/schedule/appointment\t          |  930 mx          |         |\n' +
//   '| /temples/submit-prayer-roll-names       |  11.2 s          |         |\n' +
//   '| /temples\t                              |  2 s          |         |\n' +
//   '| /temples/prayer-roll\t                  |  975 mx          |         |\n' +
//   '| /temples/details-note\t                  |  1.03 s          |         |\n' +
//   '| /temples/photo-gallery\t                |  19 s         |         |\n' +
//   '| /temples/auth/login                     |  628 ms          |         |\n').trim().split(RE.serializedNewline)

const header = lines.shift()
while((lines[lines.length-1] || '').trim().length === 0) lines.pop()

const headerDivider = lines.shift().split(RE.pipeChar)
headerDivider.shift()
headerDivider.pop()

const newHeaderDividerLine = `|${Array.from({ length: headerDivider.length }).map(entry => '').join("|")}|`

const stats = headerDivider.map(column => column.length-2)

const transformedLinesSizing = [header, newHeaderDividerLine, ...lines].map(line => {
  const lineParts = line.split(RE.pipeChar)
  lineParts.shift()
  lineParts.pop()

  const transformedLine = lineParts.map((linePart, index) => {
    let cleanLine = linePart.replaceAll(RE.serializedTab, '').trim()
    if (RE.columnLineBreak.test(cleanLine)) {
      const leader = (!cleanLine.startsWith('- ')) ? '- ' : ''
      cleanLine = leader + cleanLine.replaceAll(RE.columnLineBreak, '<br/>- ')
    }
    
    if (cleanLine.length > stats?.[index]) stats[index] = cleanLine.length
    return cleanLine
  })
  return transformedLine
})

const transformedLines = transformedLinesSizing.map(lineParts => {
  const transformedLine = lineParts.map((linePart, index) => {
    return linePart.padEnd(stats[index], ' ')
  })
  return `| ${transformedLine.join(" | ")} |`
  // return `[${headerDivider[0].length}] ` + line.replaceAll(/\\t/g, '').trim() // .slice(0, headerDivider[0].length).padEnd(headerDivider[0].length, ' ').slice(0, headerDivider[0].length-1)
})

transformedLines[1] = transformedLines[1].replaceAll(/ /g, '-')
console.log(`${transformedLines.join("\n")}`)



/*
const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

let lines = []
let inblock = false
const reduce = (line) => {
  if (line.length > 0) {
    if (line.startsWith('```')) inblock = !inblock
    
    if (inblock) {
      line = line.replaceAll(/</g, '&lt;')
    }
    lines.push(line)
  }
}


input.on('data', line => {
  reduce(line)
});

input.on('end', () => {
  console.log(lines.join("\n"))
});

input.on('error', e => {
  console.error(e)
});

 * */
