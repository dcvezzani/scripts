#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const fs = require('fs')

// console.log(">>>process.argv", process.argv)
const subject = process.argv[2]
const tier = process.argv[3]

if (!subject) {
  console.error(`Usage: node cf-get-project-source.js <subject> <tier>; e.g., node cf-stats-parse.js arp fe`)
  process.exit(1)
}

let json
try {
json = JSON.parse(fs.readFileSync(`/Users/dcvezzani/.iterm/projects.json`).toString())
} catch (err) {
  console.error(err)
}

const projectPath = json[subject][tier]?.path.replace(/\~/, '/Users/dcvezzani')
process.stdout.write(projectPath);


