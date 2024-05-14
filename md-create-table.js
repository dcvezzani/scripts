#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  variableDefinition: /^\$([^=]+)=(.*)$/,
  variableReference: /\$\{([^\}]+)\}/,
  defaultColumnSeparator: /\s*,\s*/,
  columnLineBreak: / *\/\/ *| *<br\/>\(- +\)*/g,
  anythingExceptPipe: /[^|]/g,
  explicitComma: /','/g,
  commaPlaceholder: /__comma__/g,
}

const state = {
  lines: [],
  variables: {},
  originalVariables: {},
  columnDivider: RE.defaultColumnSeparator,
  columnLineBreak: RE.linkBreak,
  columnWidths: [],
  commaPlaceholder: '__comma__',
}

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

const calculateColumnWidths = () => {
  state.columnDivider = state.variables.columnDivider || RE.defaultColumnSeparator

  const headerColumnNames = (state.lines[0] || '').split(state.columnDivider)
  state.columnWidths = Array(headerColumnNames?.length || 0).fill(0)

  state.lines = state.lines.map(line => {
    line = line.replaceAll(RE.explicitComma, state.commaPlaceholder)
    let columnValues = (line || '').split(state.columnDivider)
    columnValues = columnValues.map((columnValue, index) => {
      columnValue = columnValue.replaceAll(RE.commaPlaceholder, ',')
      if (RE.columnLineBreak.test(columnValue)) {
        // console.log(">>>dcv (md-create-table.js, , columnValue:56)", columnValue)
        const leader = (!columnValue.startsWith('- ')) ? '- ' : ''
        columnValue = leader + columnValue.replaceAll(RE.columnLineBreak, '<br/>- ')
        // console.log(">>>dcv (md-create-table.js, , columnValue:73)", columnValue)
      }
      
      const columnValueLength = (columnValue || '').length
      if (columnValueLength > state.columnWidths[index]) state.columnWidths[index] = columnValueLength
      return columnValue
    })
    return columnValues
  })
}

const renderMdTable = () => {
  state.lines = state.lines.reduce((lines, columns, index) => {

    columns = columns.map((column, index) => {
      const columnLength = (column || '').length
      if (state.columnWidths[index] > columnLength) {
        column = column.padEnd(state.columnWidths[index], ' ')
      }
      return column
    })

    const formattedLine = `| ${columns.join(' | ')} |`
    lines.push(formattedLine)

    // divider for column headers
    if (index === 0) lines.push( formattedLine.replaceAll(RE.anythingExceptPipe, '-') )

    return lines
  }, [])
}

input.on('data', line => {
  if (line.startsWith('$')) {
    const prop = parseVariableDefinition(line)
    state.variables[prop.name] = prop.value
    state.originalVariables[prop.name] = prop.originalValue
    return
  }

  if ((line || '').trim().length === 0) return

  line = transformResolveVariables(line)
  state.lines.push(line)

  // const isHeader = (state.lines.length === 0)
  // const columnDivider = state.variables?.columnDivider || RE.defaultColumnSeparator

  // const rowData = line.split(columnDivider)
  // const tableRowData = `| ${rowData.join(' | ')} |`

  // state.lines.push(tableRowData)

  // if (isHeader) state.lines.push(tableRowData.replaceAll(RE.anythingExceptPipe, '-'))
});

input.on('end', () => {
  calculateColumnWidths()
  renderMdTable()

  // process.stderr.write(`Variables: \n${JSON.stringify(state.variables, null, 2)}\n\n`)
  // console.log(state.columnWidths)
  console.log(serializeVariables())
  console.log()
  console.log(state.lines.join("\n"))
})

input.on('error', error => {
  console.error('Error', error)
})


/*

cat << 'EOL' | /Users/dcvezzani/scripts/md-create-table.js
$source=.vim/bundle/md-vim/after/ftplugin/md.vim

command,mode,description,instructions,notes,source
qc,v,surround selected text in code block,,,${source}
qk,v,create link,highlighted text should become the visible link//clipboard should contain the resource being linked//if clipboard content starts with http',' resource should automatically be populated,,${source}
qb,v,make text bold,,,${source}
qfc,v,capitalize first letter for each word in selection,,,${source}
EOL

*/
