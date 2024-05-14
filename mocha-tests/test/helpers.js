const fs = require('fs')
const { config } = require('./config')
const HTML = require("html")

function cloneObject(obj) {
  try {
    return JSON.parse(JSON.stringify(obj))
  } catch (err) {
    return obj
  }
}

module.exports = (options={}) => {
  const {UPDATE_ALL_EXPECTED, VERBOSE, LOG_INDENTATION} = options
  
  function log(message) {
    if (VERBOSE) console.log(`${LOG_INDENTATION}${message}`)
  }
  
  function getFilename({path, fetchArgs, label}) {
    let filenamePrefix = (!!label) ? `${path}-${label}` : path
    filenamePrefix = filenamePrefix.slice(1).replaceAll(/[^a-zA-Z0-9]+/g, '-')

    const filename = `./test/data/${fetchArgs[1].method.toLowerCase()}-${filenamePrefix}`
    return filename
  }

  function recordAndGatherJson(payload, {update=false, filename}) {
    try {
      const actualKeys = gatherKeys(payload)

      updateExpected(update || !fs.existsSync(`${filename}-keys.json`), {filename, payload, actualKeys})

      writeFile(`${filename}-actual.json`, payload)
      writeFile(`${filename}-keys-actual.json`, actualKeys)

      const expectedKeys = readFile(`${filename}-keys.json`)

      return {payload, actualKeys, expectedKeys}
    } catch (err) {
      console.error(err)
      throw err
    }
  }

  function recordAndGatherText(_payload, {update=false, filename}) {
    const payload = HTML.prettyPrint(_payload, {indent_size: 2})
    
    writeFile(`${filename}-actual.html`, payload)
    return {payload, actualKeys: {}, expectedKeys: {}}
  }

  function updateExpected(update=false, {filename, payload, actualKeys}) {
    if (UPDATE_ALL_EXPECTED || update) {
      writeFile(`${filename}.json`, payload)
      writeFile(`${filename}-keys.json`, actualKeys)
    }
  }

  function writeFile(filename, content) {
    let _content = content
    if (typeof _content !== 'string') {
      _content = JSON.stringify(content, null, 2)
    }

    fs.writeFileSync(filename, _content)
    log(`Content written to file: ${filename}`)
  }

  function readFile(filename) {
    let content = fs.readFileSync(filename).toString()
    if (filename.endsWith('.json')) content = JSON.parse(content)

    log(`Content read from file: ${filename}`)
    return content
  }

  const gatherKeys = (obj = {}, sensitiveTokens = ["secret", "password"]) => {

    //called with every property and its value
    function process(obj, key, value) {
      // if (
      // 	sensitiveTokens.some((entry) =>
      // 		key.toLowerCase().includes(entry.toLowerCase())
      // 	)
      // )
      // 	value = "**********";
      obj[key] = (typeof value === 'object') ? value : typeof value;
    }

    // get unique object values for arrays
    function filterUnique(o) {
      const filtered = o.reduce((filtered, entry) => {
        if (!filtered.includes(JSON.stringify(entry))) filtered.push(JSON.stringify(entry))
        return filtered
      }, [])

      return filtered.map(entry => JSON.parse(entry))
    }

    function traverse(o, func) {
      // let o = (!!_o && Array.isArray(_o)) ? _o.slice(0,1) : _o

      for (var i in o) {
        func.apply(this, [o, i, o[i]]);
        if (o[i] !== null && typeof o[i] == "object") {
          //going one step down in the object tree!!
          traverse(o[i], func);
        }

        if (Array.isArray(o[i])) {
          o[i] = filterUnique(o[i])
        }
      }

      return o;
    }

    //that's all... no magic, no bloated framework
    let keysReport = traverse(cloneObject(obj), process);

    if (Array.isArray(keysReport)) {
      keysReport = filterUnique(keysReport)
    }

    return keysReport
  }

  return {
    getFilename,
    recordAndGatherJson,
    recordAndGatherText,
    updateExpected,
    writeFile,
    readFile,
    log,
  }
}
