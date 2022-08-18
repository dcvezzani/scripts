const fs = require('fs')
const _wrapText = require("wrap-text");

const wrapText = function(content, col=40, {prefix='', suffix=''} = {}) {
  col = (!!col) ? col : 40
  
  const lines = _wrapText(content, col).split(/\n/)
  return lines.map((line, index) => {
    if (index === 0) return line
    return `${prefix}${line}${suffix}`
  }).join("\n")
}

const props = JSON.parse(fs.readFileSync(`/Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/graphviz-idm-properties.json`).toString())

// console.log(">>>props", props)

const configNodes = props.config.map(group => {
  
// console.log(">>>group", group)
// console.log(">>>Object.values(group)[0]", Object.values(group)[0])

const groupName = Object.keys(group)[0]

const groupNodes = Object.values(group)[0].map(entry => {
  // console.log(">>>entry", entry)
  const sampleValue = (typeof entry.sampleValue == 'string') ? `'${entry.sampleValue}'` : (!!entry.sampleValue) ? `${entry.sampleValue}` : ''
  const label = `${groupName}_${entry.name}`.replace(/\./g, '_')

  return `${label} [color=orange,width=2.0,label=<<TABLE CELLBORDER="0" CELLSPACING="0" BORDER="0"><TR><TD PORT="cell757" ALIGN="LEFT" BALIGN="LEFT">${entry.name}<BR ALIGN="LEFT"/><BR ALIGN="LEFT"/><FONT POINT-SIZE="12">${wrapText(entry.description, null, {prefix: `<BR ALIGN="LEFT"/>`})}</FONT></TD></TR></TABLE>>]`
  })


  const nodeNames = Object.values(group)[0].map(entry => `${groupName}_${entry.name}`.replace(/\./g, '_'))
  const subgraph = `subgraph cluster_${groupName.replace(/\./g, '_')}  {
      label=<${groupName}>;
      ${nodeNames.join('; ')};
      graph[style=dotted];
    }`
  // console.log(subgraph)

  return {groupName, nodes: groupNodes, subgraph, nodeNames}
})

const parentGraph = `
  subgraph cluster_config  {
    graph[labeljust=l,shape=point,style=invis,label=<<b>Config</b>>,style=dotted];
    
    ${configNodes.map(entry => entry.subgraph).join("\n\n    ")}
  }
`

const firstNodes = configNodes.map(entry => entry.nodeNames[0])
console.log("  " + configNodes.map(entry => entry.nodes.join("\n\n  ")).join("\n\n  ") + "\n")

console.log(parentGraph)

const edges = []
for (let i=0; i<(firstNodes.length-1); i++){
  edges.push(`${firstNodes[i]} -> ${firstNodes[i+1]} [shape=point,style=invis]`)
}

console.log("  " + edges.join("\n  "))


// console.log(`${groupName.replace(/\./, '_')}_${entry.name} [color=blue,label=<${entry.name}<br/>(<font color="black">${sampleValue}</font>)>]`)
// oauthRoutesLogin [color=blue,label=<LOGIN<br/>(<font color="black">'/auth/login'</font>)>]

