const fs = require('fs')
const _config = JSON.parse(fs.readFileSync('./test/config.json').toString())

// let buff = Buffer.from(`${_config.authorization.username}:${_config.authorization.password}`)
// _config.authorization.basic = buff.toString('base64');

const commonConfig = Object.keys(_config).reduce((obj, key) => {
  if (!['local', 'test', 'stage', 'production'].includes(key)) {
    obj[key] = JSON.parse(JSON.stringify(_config[key]))
  }
  return obj
}, {})

const ENV = process.env.TEST_ENV || "local"
// console.log(">>>_config[ENV]", _config[ENV])
const envConfig = Object.keys(_config[ENV] || {}).reduce((obj, key) => {
  obj[key] = JSON.parse(JSON.stringify(_config[ENV][key]))
  return obj
}, {})

module.exports.config = {...commonConfig, ...envConfig, env: ENV}

module.exports.filteredObjectKeys = function(data, token='~') {
  return Object.keys(data).reduce((obj, key) => {
    // console.log(">>>key", key)
    if (key.startsWith('~')) return obj
    obj[key] = data[key]
    return obj
  }, {})
}
