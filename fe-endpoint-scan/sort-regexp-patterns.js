#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const endpoint = process.argv[2]
// const fs = require('fs')
// const dmerge = require('deepmerge')

// // When merging arrays, filter out duplicate values
// const arrayDistictValues = (target, source, options) => {
//   const destination = target.slice() // clone array
// 	source.forEach((item, index) => {
//     if (!destination.includes(item)) destination.push(item)
// 	})
// 	return destination
// }

async function main() {
  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  const entries = data.split(/ +/)
  entries.sort()
  process.stdout.write(entries.join(' '))
}

main();


