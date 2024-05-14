#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const reducer = (obj, parent) => {
if (typeof obj !== 'object') return {obj, parent}

if (obj.expression?.right) return reducer(obj.expression.right, obj.expression?.left?.property?.name || obj.expression.right?.type)

if (!obj?.body) {
  if (obj.type === 'VariableDeclaration') {
    let name = obj.declarations.find(entry => entry.type === 'VariableDeclarator')?.id?.name

    if (!name) {
      const properties = obj.declarations.find(entry => entry.type === 'VariableDeclarator')?.id?.properties || []
      name = (properties || []).find(entry => entry.type === 'Property')?.key?.name
    }

    return {type: obj.type, name, start: obj.loc?.start?.line, end: obj.loc?.end?.line, parent: parent || 'global'}
  }

  return {type: obj.type, name: obj.key?.name, start: obj.loc?.start?.line, end: obj.loc?.end?.line, parent}
}

if (Array.isArray(obj.body)) return obj.body.reduce((coll, entry) => {
  const payload = reducer(entry, parent)
  if (Array.isArray(payload)) coll = coll.concat(payload)
  else coll.push(payload)
  return coll
}, [])

if (typeof obj.body === 'object') return reducer(obj.body, parent)
}

const identifyCodeBlocks = (data) => {
  return reducer(JSON.parse(data))
}

const split = require('split');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {data: ''}

async function main() {
  for await (const chunk of process.stdin) state.data += chunk;

  const payload = (Array.isArray(state.data) && state.data.length > 0) ? identifyCodeBlocks(state.data.toString()) : []
  
  // process all the data and write it back to stdout
  process.stdout.write(JSON.stringify(payload, null, 2));
}

main();
