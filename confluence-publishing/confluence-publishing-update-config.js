#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const BASE_PATH = process.argv[2]

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

let lines = []
const reduce = (line) => {
  if (line.length > 0) {
    // update line
    lines.push(line)
  }
}

let config = {}
const filename = `${BASE_PATH}/.confluence.json`
let jsessionid = null

input.on('data', data => {
  if (Object.keys(config).length === 0) {
    try {
      config = JSON.parse(require('fs').readFileSync(filename).toString())
    } catch(err) {
      console.error(`Unable to load "${BASE_PATH}/.confluence.json"`)
      process.exit(1)
    }

    if (!jsessionid) jsessionid = data

    // reduce(line)
  }
});

input.on('end', () => {
  try {
    config.JSESSIONID = jsessionid
    require('fs').writeFileSync(filename, JSON.stringify(config, null, 2))
    console.log(JSON.stringify(config))
  } catch(err) {
    console.error(`Unable to update "${BASE_PATH}/.confluence.json"`)
    process.exit(1)
  }
});

input.on('error', e => {
  console.error(e)
});

