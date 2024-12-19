#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

// const graphvizConfigPath = process.argv[2]

// const { unlinkSync, existsSync } = require('node:fs');

// const configTemplate = require(graphvizConfigPath)

const RE = {
  lookingFor: {
    router: /^\s*router\./,
    routerNoPattern: /^\s*router\.([^\(]+)\(\s*$/,
    routerAndPattern: /^\s*router\.([^\(]+)\(\s*(.+)/,
    routerPattern: /^\s*([^,]+)/,
    middleware: /\b([^M]+Middleware\.|require\([^\)]+\))[^\)]*/,
  },
}

const state = {
  lookingFor: 'router',
  // router, routerPattern, middleware

  xroutes: [],
  routes: {},
  currentLine: null,
  currentRoute: null,
  middleware: {},
}

const cleanValue = (value) => {
  return value.replace(/^\W+/, '').replace(/\W+$/, '').replaceAll(/['"`]/g, '')
}

const cleanName = (value) => {
  return value.trim().replaceAll(/['"`]/g, '')
}

const processLine = (line) => {
  if (state.lookingFor == 'middleware') {
    const pattern = (line.match(RE.lookingFor.router) || [null, null])[0]

    if (pattern) {
      state.lookingFor = 'router'
    }
  }
  
  if (state.lookingFor == 'router') {
    const pattern = (line.match(RE.lookingFor.router) || [null, null])[0]

    if (pattern) {
      state.lookingFor = 'routerPattern'
    } else return
  }

  if (state.lookingFor == 'routerPattern') {
    const routerNoPattern = (line.match(RE.lookingFor.routerNoPattern) || [null, null])[1]
    if (routerNoPattern) return

    const routerAndPattern = (line.match(RE.lookingFor.routerAndPattern) || [null, null])[2]
    let pattern = (line.match(RE.lookingFor.routerPattern) || [null, null])[1]

    if (routerAndPattern) {
      const parts = routerAndPattern.split(',')
      const patternName = cleanName(parts[0])

      state.currentRoute = patternName

      state.routes[patternName] = {name: patternName, lines: []}
      // state.routes.push({name: patternName, middleware: []})
      state.lookingFor = 'middleware'
      line = parts.slice(1).join(',')

    } else if (pattern) {
      pattern = cleanName(pattern)

      state.currentRoute = pattern
      
      state.routes[pattern] = {name: pattern, lines: []}
      // state.routes.push({name: pattern, middleware: []})
      state.lookingFor = 'middleware'
      line = line.replace(RE.lookingFor.routerPattern, '')
    }
  }

  if (state.lookingFor == 'middleware') {
    const middleware = (line.match(RE.lookingFor.middleware) || [null, null])[0]
    if (middleware) {
      state.routes[state.currentRoute].lines.push(cleanValue(middleware))
      // state.routes[state.routes.length-1].middleware.push(cleanValue(middleware))
    }
    
    const routerAndPattern = (line.match(RE.lookingFor.routerAndPattern) || [null, null])[1]
    if (routerAndPattern) {
      state.lookingFor = 'router'
    }

  }
}

async function main() {
  // console.log(`Running scraper-si-001.js...`)

  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  const lines = data.split(/[\r\n]+/)

  for (line of lines) {

    processLine(line)

// console.log(">>>dcv (scraper-si-001.js, , line:19)", line, state.lookingFor)
  }

  

// console.log(">>>dcv (scraper-si-001.js, , state.routes:74)", JSON.stringify(state.routes, null, 2))
  console.log(JSON.stringify(state.routes, null, 2))

}

main();


