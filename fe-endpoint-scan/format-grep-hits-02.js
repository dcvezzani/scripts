#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const graphvizConfigPath = process.argv[2]
const endpoint = process.argv[3]
const uncommittedFiles = (process.argv[4] || '').split(/[\r\n]+/)

const fs = require('fs')
const dmerge = require('deepmerge')

const configTemplate = require('./load-graphviz-config')(graphvizConfigPath)

const filenames = configTemplate.files

// When merging arrays, filter out duplicate values
const arrayDistictValues = (target, source, options) => {
  const destination = target.slice() // clone array
	source.forEach((item, index) => {
    if (!destination.includes(item)) destination.push(item)
	})
	return destination
}

async function main() {
  console.log(`Running format-grep-hits-02.js...`)

  let data = "";
  for await (const chunk of process.stdin) data += chunk;
  // console.log(data.toString())

  let byResourceJson = {}
  if (fs.existsSync(filenames.byResource)) {
    const byResourceJsonPayload = fs.readFileSync(filenames.byResource).toString()
    if (byResourceJsonPayload.trim().length > 0) {
      byResourceJson = JSON.parse(byResourceJsonPayload)
    }
  }

  let byEndpointJson = {}
  if (fs.existsSync(filenames.byEndpoint)) {
    const byEndpointJsonPayload = fs.readFileSync(filenames.byEndpoint).toString()
    if (byEndpointJsonPayload.trim().length > 0) {
      byEndpointJson = JSON.parse(byEndpointJsonPayload)
    }
  }
  
  let lines = data.toString().trim()
  lines = (lines.length > 0) ? lines.split(/[\r\n]+/) : ["no-reference"]
  // console.log(JSON.stringify({endpoint, lines}, null, 2))

  const payload = dmerge.all([byEndpointJson, {[endpoint]: {name: endpoint, lines}}], { arrayMerge: arrayDistictValues });
  console.log(`Appending content to file... ${filenames.byEndpoint}`)
  fs.writeFileSync(filenames.byEndpoint, JSON.stringify(payload, null, 2))

  const reducedLines = lines.reduce((coll, entry) => {
    if (uncommittedFiles.includes(entry)) return coll

    if (!coll[entry]) coll[entry] = []
    coll[entry].push(endpoint)

    return coll
  }, {})
  const payload_02 = dmerge.all([byResourceJson, reducedLines], { arrayMerge: arrayDistictValues });

  console.log(`Appending content to file... ${filenames.byResource}`)
  fs.writeFileSync(filenames.byResource, JSON.stringify(payload_02, null, 2))
}

main();


