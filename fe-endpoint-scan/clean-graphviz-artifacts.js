#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const graphvizConfigPath = process.argv[2]

const { unlinkSync, existsSync } = require('node:fs');

const configTemplate = require('./load-graphviz-config')(graphvizConfigPath)

async function main() {
  console.log(`Running clean-graphviz-artifacts.js...`)

  // let data = "";
  // for await (const chunk of process.stdin) data += chunk;

  for (key in configTemplate.files) {
    const filename = configTemplate.files[key]
    console.log(`Cleaning file... ${filename}`)
    if (existsSync(filename)) unlinkSync(filename)
  }
}

main();

