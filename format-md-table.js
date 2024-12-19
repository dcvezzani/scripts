#!/Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

// console.log(process.argv)

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  pipeChar: /\|/, 
  serializedNewline: /\n/,
  serializedTab: /\t/g,
  // columnLineBreak: / *\/\/ *| *<br\/>\(- +\)*/g,
  columnLineBreak: / *;; *| *<br\/>\(- +\)*/g,
  variableDefinition: /^\$([^=]+)=(.*)$/,
  variableReference: /\$\{([^\}]+)\}/,
}

const state = {
  lines: [],
  variables: {
    columnLineBreakEnabled: "true",
  },
  originalVariables: {},
  // columnDivider: RE.defaultColumnSeparator,
  // columnLineBreak: RE.linkBreak,
  // columnWidths: [],
  // commaPlaceholder: '__comma__',
}


// const lines = (process.argv[2] || '').trim().split("\n")

// const lines = ('| Resource                                | ave res time | focus |\n' + 
//   '|-----------------------------------------|------------|---------|\n' +
//   '| /temples/schedule/appointment\t          |  930 mx          |         |\n' +
//   '| /temples/submit-prayer-roll-names       |  11.2 s          |         |\n' +
//   '| /temples\t                              |  2 s          |         |\n' +
//   '| /temples/prayer-roll\t                  |  975 mx          |         |\n' +
//   '| /temples/details-note\t                  |  1.03 s          |         |\n' +
//   '| /temples/photo-gallery\t                |  19 s         |         |\n' +
//   '| /temples/auth/login                     |  628 ms          |         |\n').trim().split(RE.serializedNewline)

const serializeVariables = () => {
  return Object.entries(state.originalVariables).map(([key, value]) => {
    return `$${key}=${value}` 
  }).join("\n")
}

const parseVariableDefinition = (line) => {
  let [_, name, originalValue] = line.match(RE.variableDefinition) || []
  let value = originalValue
  if (RE.variableReference.test(value)) value = transformResolveVariables(value)
  return {name, value, originalValue}
}

const parseVariableReference = (line) => {
  const [_, name] = line.match(RE.variableReference) || []
  return name
}

const transformResolveVariables = (line) => {
  let cnt = 0
  while (RE.variableReference.test(line) && cnt < 10) {
    const name = parseVariableReference(line)
    const value = state.variables[name]
    const reVariableName = new RegExp(`\\$\\{${name}\\}`, 'g')
    if (value) line = line.replaceAll(reVariableName, value)
    cnt++
  }

  return line
}

const transform = () => {
  const lines = state.lines

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
      cleanLine = transformResolveVariables(cleanLine)

      if (state.variables.columnLineBreakEnabled === "true" && RE.columnLineBreak.test(cleanLine)) {
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

  state.lines = transformedLines
}

input.on('data', line => {
  if (line.startsWith('$')) {
    const prop = parseVariableDefinition(line)
    state.variables[prop.name] = prop.value
    state.originalVariables[prop.name] = prop.originalValue
    return
  }

  if ((line || '').trim().length === 0) return
  
  state.lines.push(line)
});

input.on('end', () => {
  transform()

  if (Object.keys(state.originalVariables || {}).length > 0) {
    console.log(serializeVariables())
    console.log()
  }

  console.log(state.lines.join("\n"))
})

input.on('error', error => {
  console.error('Error', error)
})
  
/*

cat << 'EOL' | /Users/dcvezzani/scripts/format-md-table.js
$source=.vim/bundle/md-vim/after/ftplugin/md.vim

| command | mode | description                                        | instructions                                                                                                                                                                                       | notes | source                                   |
|---------|------|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|------------------------------------------|
| qc      | v    | surround selected text in code block       |                                                                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qk      | v    | create link                                        | - highlighted text should become the visible link<br/>- clipboard should contain the resource being linked<br/>- if clipboard content starts with http, resource should automatically be populated |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qb      | v    | make text bold                                     |                                                                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qfc     | v,n  | capitalize first letter for each word in selection | [📊 fig 1](#-fig-1-create-title-from-selection)                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
EOL




cat << 'EOL' | /Users/dcvezzani/scripts/format-md-table.js
$source=.vim/bundle/md-vim/after/ftplugin/md.vim

| command | mode | description                                        | instructions                                                                                                                                                                                       | notes | source                                   |
|---------|------|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|------------------------------------------|
| qc      | v    | surround selected text in code block       |                                                                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qk      | v    | create link                                        | - highlighted text should become the visible link<br/>- clipboard should contain the resource being linked<br/>- if clipboard content starts with http, resource should automatically be populated |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qb      | v    | make text bold                                     |                                                                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
| qfc     | v    | capitalize first letter for each word in selection |                                                                                                                                                                                                    |       | .vim/bundle/md-vim/after/ftplugin/md.vim |
EOL


*/

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
