module.exports = (graphvizConfigPath) => {
  let configTemplate
  try { configTemplate = require(graphvizConfigPath) } catch(error) { }
  if (!configTemplate) try { configTemplate = require(`${process.cwd()}/${graphvizConfigPath}`) } catch(error) { }
  if (!configTemplate) {
    console.error(`Unable to load config file: ${graphvizConfigPath} || ${`${process.cwd()}/${graphvizConfigPath}`}`)
    process.exit(1)
  }

  return configTemplate
}
