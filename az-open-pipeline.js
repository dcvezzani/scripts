#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const fs = require('fs')

// console.log(">>>process.argv", process.argv)
const subject = process.argv[2]
const tier = process.argv[3]
const definitionIdType = process.argv[4]

if (!subject) {
  console.error(`Usage: node az-open-pipeline.js <subject> <tier> <type>\ntier: fe, ws, cms\ntype: m=memcached, s=sidecar; defaults to basic tier\ne.g., node az-open-pipeline.js arp fe`)
  process.exit(1)
}

let json
try {
json = JSON.parse(fs.readFileSync(`/Users/dcvezzani/.iterm/projects.json`).toString())
} catch (err) {
  console.error(err)
}

if (tier) {
  let definitionIdKey = 'definitionId'
  switch(definitionIdType) {
    case 'm': {
      definitionIdKey = 'memcachedDefinitionId'
      break;
    }
    case 's': {
      definitionIdKey = 'sidecarDefinitionId'
      break;
    }
  }
  const definitionId = json[subject][tier]?.azure[definitionIdKey]
  process.stdout.write(`https://dev.azure.com/churchofjesuschrist/PTH-COR%20-%20Team%201/_build?definitionId=${definitionId}`)

} else {
  const definitionScope = json[subject]['azure-scope']
  process.stdout.write(`https://dev.azure.com/churchofjesuschrist/PTH-COR%20-%20Team%201/_build?definitionScope=${definitionScope}`)
}

