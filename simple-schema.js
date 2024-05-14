#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const fs = require('fs')

const filename = process.argv[2]

if (!filename || !fs.existsSync(filename)) {
  console.log(`Usage: ~/scripts/simple-schema.js <filename>`)
  process.exit(1)
}

const obj = JSON.parse(fs.readFileSync(filename).toString())

const parseTree = (obj) => {
  if (typeof obj === 'undefined' || obj === null) return null
  if (typeof obj !== 'object' && !Array.isArray(obj)) return typeof obj 

  if (Array.isArray(obj)) {
    return [parseTree(obj[0])]
  } 

  debugger
  const keys = Object.keys(obj)
  return keys.reduce((coll, key) => {
    coll[key] = parseTree(obj[key])
    return coll
  }, {})
}

console.log(JSON.stringify(parseTree(obj), null, 2))
