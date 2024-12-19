#! /Users/dcvezzani/.nvm/versions/node/v20.11.0/bin/node

const graphvizConfigPath = process.argv[2]

const fs = require('fs')

const RE = {
  pipe: /\|/g,
}

const configTemplate = require('./load-graphviz-config')(graphvizConfigPath)

const filenames = configTemplate.files

const payloads = {
  byResource: JSON.parse(fs.readFileSync(filenames.byResource).toString()),
  byEndpoint: JSON.parse(fs.readFileSync(filenames.byEndpoint).toString()),
}


configTemplate.endpoints.nodes = []
configTemplate.resources.nodes = []
configTemplate.relationships.edges = []

const xupdateEndpointNodes = () => {
  configTemplate.endpoints.nodes = Object.values(payloads.byEndpoint).map(endpointEntry => {
console.log(">>>dcv (generate-graphviz-config.js, , endpointEntry:27)", endpointEntry)
    const resolvedAttrs = resolveNodeAttributes({label: endpointEntry.name})
    return resolvedAttrs
  })
}

const updateEndpointNodes = () => {
  configTemplate.endpoints.nodes = Object.values(payloads.byEndpoint).map(endpointEntry => {
    const configTemplatePattern = resolvePattern(endpointEntry.name)

    const resolvedAttrs = resolveNodeAttributes({label: endpointEntry.name, ...configTemplatePattern}, {excludeAttrs: ['endpointTokens', 'token', 'color', 'colorToken'], // , 'colorToken', 'color'
      cb: (attrs) => {
        attrs.fillcolor = configTemplatePattern.color
        attrs.fillcolorToken = configTemplatePattern.colorToken
      },
    })
    
    return resolvedAttrs
  })
}


const resolvePatterns = () => {
  configTemplate.patterns = Object.keys(configTemplate.patterns).reduce((resolvedPatterns, pattern) => {
    const currentPattern = configTemplate.patterns[pattern]
    const colorToken = currentPattern.color
    const resolvedAttrs = resolveNodeAttributes(currentPattern, {excludeAttrs: []})
    // { cb: (attrs) => { attrs.colorToken = colorToken attrs.color = resolveColor(colorToken) || attrs.color }, excludeAttrs: [], }

    resolvedPatterns[pattern] = resolvedAttrs
    return resolvedPatterns
  }, {})
}

const resolvePattern = (value) => {
  let patternKey = Object.keys(configTemplate.patterns).find(pattern => {
    const patternInst = configTemplate.patterns[pattern]
    const patternToken = patternInst?.token || patternInst?.endpointTokens

    let isMatch = false
    if (Array.isArray(patternToken)) isMatch = patternToken.some(entry => value.includes(entry))
    else isMatch = value.includes(patternToken)

    return isMatch
  })

  const patternAttrs = patternKey && configTemplate.patterns[patternKey] || {}
  patternKey = (patternKey) ? {patternKey} : {}
  return {...patternKey, ...patternAttrs}
}

const resolveColor = (value) => {
  let nodeColor
  if (value.startsWith('$colors.')) {
    const colorName = value.split('.')[1]
    nodeColor = configTemplate.colors[colorName]
  }
  return nodeColor || value
}

const resolveIdFromLabel = (label, options={}) => {
  if (!label) return null

  const { prefix='node_', postfix=null } = options

  const id = label.replace(/^\W+/, '').replace(/\W+$/, '')
    .replace(/\/index\.js$/, '')
    .replace(/\.js$/, '')
    .replaceAll(/\W+/g, '_')
  const _prefix = (!prefix) ? '' : `${prefix}_`
  const _postfix = (!postfix) ? '' : `_${postfix}`

  return `${_prefix}${id}${_postfix}`
}

const resolveNodeAttributes = (node, options={}) => {
  const { cb=null, excludeAttrs=['token'] } = options

  const nodeAttributes = Object.keys(node || {}).reduce((nodeAttributes, nodeAttributeName) => {
    if (excludeAttrs.includes(nodeAttributeName)) return nodeAttributes

    const value = node[nodeAttributeName]

    if (Array.isArray(value)) {
      nodeAttributes[nodeAttributeName] = value
      return nodeAttributes
    }

    if (nodeAttributeName === 'label' && value.includes('|')) {
      nodeAttributes[`${nodeAttributeName}Type`] = 'html'
    }

    if (['colorToken'].includes(nodeAttributeName)) {
      nodeAttributes[nodeAttributeName] = value

    } else if (value.startsWith('$colors.')) {
      nodeAttributes[`${nodeAttributeName}Token`] = value
      nodeAttributes[nodeAttributeName] = resolveColor(value)

    } else {
      nodeAttributes[nodeAttributeName] = value
    }

    if (typeof cb === 'function') cb(nodeAttributes)
    // updateRelationshipEdges(resourceEntry, {node})

    return nodeAttributes
  }, {})

  const nodeId = resolveIdFromLabel(nodeAttributes.label, {prefix: 'node'})
  if (nodeId) nodeAttributes.id = nodeId

  return nodeAttributes
}  

const updateRelationshipEdges = (resourceEntry, options={}) => {
  let { configTemplatePattern } = options

  if (!configTemplatePattern) {
    configTemplatePattern = resolvePattern(resourceEntry)
  }

  const resourceEntryId = resolveIdFromLabel(resourceEntry, {prefix: 'node'})
  payloads.byResource[resourceEntry].forEach(entry => {

    const entryId = resolveIdFromLabel(entry, {prefix: 'node'})
    configTemplate.relationships.edges.push({
      nodes: [
        {name: resourceEntry, id: resourceEntryId}, 
        {name: entry, id: entryId}, 
      ],
      color: configTemplatePattern.color,
      colorToken: configTemplatePattern.colorToken,
    })
  })
}

const updateResourceNodes = () => {
  configTemplate.resources.nodes = Object.keys(payloads.byResource).map(resourceEntry => {
    const configTemplatePattern = resolvePattern(resourceEntry)

    const nodeAttributes = resolveNodeAttributes({label: resourceEntry, ...configTemplatePattern}, {excludeAttrs: ['token', 'color', 'colorToken'], // , 'colorToken', 'color'
      cb: (attrs) => {
        attrs.fillcolor = configTemplatePattern.color
        attrs.fillcolorToken = configTemplatePattern.colorToken
      },
    })
    // {cb: (attrs) => { attrs.fillcolor = attrs.color attrs.fillcolorToken = attrs.colorToken && attrs.colorToken.toString() delete attrs.color delete attrs.colorToken }}

    updateRelationshipEdges(resourceEntry, {configTemplatePattern})

    // return {label: resourceEntry, ...nodeAttributes}
    return nodeAttributes
  })
}

const updateDefaultAttributes = (obj) => {
    obj.defaults = resolveNodeAttributes(obj.defaults)
    // {cb: (attrs) => { attrs.fillcolor = attrs.color delete attrs.color }}
}

async function main() {
  console.log(`Running generate-graphviz-config.js...`)

  // let data = "";
  // for await (const chunk of process.stdin) data += chunk;

  resolvePatterns()
  updateEndpointNodes()
  updateResourceNodes()

  updateDefaultAttributes(configTemplate.endpoints)
  updateDefaultAttributes(configTemplate.resources)
  updateDefaultAttributes(configTemplate.relationships)

  console.log(`Writing content to file... ${filenames.graphvizConfig}`)
  fs.writeFileSync(filenames.graphvizConfig, JSON.stringify(configTemplate, null, 2))
}

main();


