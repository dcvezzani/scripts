#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const graphvizConfigPath = process.argv[2]
const graphvizShellPath = graphvizConfigPath.replace(/\.js$/, '.sh')
const graphvizHtmlPath = graphvizConfigPath.replace(/\.js$/, '.html')

const { writeFileSync, chmodSync, cpSync, existsSync, lsSync, readdirSync } = require('node:fs');

try {
  if (!existsSync(graphvizConfigPath)) {
    console.log(`Creating new config... ${graphvizConfigPath}`)
    cpSync(`${__dirname}/graphviz-config.js`, graphvizConfigPath)
  } else {
    console.log(`Using existing config... ${graphvizConfigPath}`)
  }
} catch(error) {
  console.error(`Unable to use config file: ${graphvizConfigPath}`, error)
  process.exit(1)
}

// let configTemplate
// if (existsSync(graphvizConfigPath)) configTemplate = require(graphvizConfigPath)
// else if (existsSync(`${process.cwd()}/${graphvizConfigPath}`)) configTemplate = require(`${process.cwd()}/${graphvizConfigPath}`)
// else {
//   console.error(`Unable to load config file: ${graphvizConfigPath} || ${`${process.cwd()}/${graphvizConfigPath}`}`)
//   process.exit(1)
// }

const configTemplate = require('./load-graphviz-config')(graphvizConfigPath)

// let configTemplate
// try { configTemplate = require(graphvizConfigPath) } catch(error) { }
// if (!configTemplate) try { configTemplate = require(`${process.cwd()}/${graphvizConfigPath}`) } catch(error) { }
// if (!configTemplate) {
//   console.error(`Unable to load config file: ${graphvizConfigPath} || ${`${process.cwd()}/${graphvizConfigPath}`}`)
//   process.exit(1)
// }

async function main() {
  console.log(`Running clean-graphviz-artifacts.js...`)

  // let data = "";
  // for await (const chunk of process.stdin) data += chunk;

  let formatGrepHitsBlock = `
# Since 'grep.tokens' and/or 'grep.dirs' have not been provided, these files
# will need to be created before running the script.  Also any cleaning that
# needs to take place will need to be done manually
# 
# - ${configTemplate.files.byResource}
# - ${configTemplate.files.byEndpoint}
`  

  if (configTemplate?.grep?.tokens && configTemplate?.grep?.dirs) {
  formatGrepHitsBlock = `
~/scripts/fe-endpoint-scan/clean-graphviz-artifacts.js "$graphvizConfig"

for re in $(echo '${configTemplate.grep.tokens.join("' '")}' | ~/scripts/fe-endpoint-scan/sort-regexp-patterns.js); do
uncommittedFiles=$(git-ls u)
grep -rlE $re ${configTemplate.grep.dirs.join(' ')} | grep -vE '\\.sw?' | ~/scripts/fe-endpoint-scan/format-grep-hits-02.js "$graphvizConfig" "$re" "$uncommittedFiles"
done
`
  }

  console.log(`Writing content to file... ${graphvizShellPath}`)
  writeFileSync(graphvizShellPath, `#!/bin/bash

graphvizConfig=${graphvizConfigPath}
${formatGrepHitsBlock}
~/scripts/fe-endpoint-scan/generate-graphviz-config.js "$graphvizConfig"
~/scripts/fe-endpoint-scan/generate-graphviz-dot.js "$graphvizConfig"

fdp -Tsvg ${configTemplate.files?.graphvizDot} > ${graphvizHtmlPath}; open ${graphvizHtmlPath}
`)

  console.log(`Updating permissions to allow execution... ${graphvizShellPath}\n`)
  chmodSync(graphvizShellPath, 0o775)

console.log(`The following files should be generated from running the ${graphvizShellPath} script:

${JSON.stringify(configTemplate.files, null, 2)}\n`)

}

main();


