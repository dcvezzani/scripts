#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

// const { unlinkSync, existsSync, readFileSync } = require('node:fs');

async function main() {
  // console.log(`Running scraper-si-001.js...`)

  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  routes = JSON.parse(data)

  const flattenedMiddlewareEntries = Object.values(routes).reduce((mw, entry) => {
    if (!entry.lines || entry.lines.length === 0) entry.lines = ['n/a']
    return mw.concat(entry.lines)
  }, [])

  const mwSet = new Set(flattenedMiddlewareEntries)
// console.log(">>>dcv (scraper-si-001.js, , mwSet:120)", mwSet)

  const middlewareResources = Array.from(mwSet)
// console.log(">>>dcv (scraper-si-002.js, , middlewareResources:22)", middlewareResources)

  const byMiddlewareResource = {}
  for (resource of middlewareResources) {
    byMiddlewareResource[resource] = []
    for (route in routes) {
      const routeValue = routes[route]
      if (routeValue.lines.includes(resource)) byMiddlewareResource[resource].push(route)
    }
  }

  console.log(JSON.stringify(byMiddlewareResource, null, 2))
// console.log(">>>dcv (scraper-si-002.js, , line:19)", data)
}

main();

