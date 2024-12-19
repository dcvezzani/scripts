#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const { exec } = require("child_process");

const WRAP_MIN = process.env.WRAP_MIN || 10
const GENERATE_CODE = (process.env.GENERATE_CODE === 'true')

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  empty: /^$/,
  end: /$/,
  fileName: /^#+ +(.+) *$/,
  directionalLine: /^- /,
  indexToken: /\$\{index\}/,
  nodeNameToken: /\$\{nodeNameToken\}/,
  formattedContentToken: /\$\{formattedContentToken\}/,
  clusterNameToken: /\$\{clusterNameToken\}/,
  clusterName: /\$\{clusterName\}/,
  nodeNamesToken: /\$\{nodeNamesToken\}/,
  highlightedToken: /\{([^\}]+)\}/g,
  space: /\s/,
  spaces: /\s+/,
  nonAlphaNumeric: /[^a-zA-Z0-9]+/g,
  endsWithNumeric: /_\d\d$/,
  nodes: /\$\{nodes\}/,
  clusters: /\$\{clusters\}/,
  vectors: /\$\{vectors\}/,
  sourceClusterName: /\$\{sourceClusterName\}/,
  destinationClusterName: /\$\{destinationClusterName\}/,
  fillcolor: /\$\{fillcolor\}/,
  textColor: /\$\{textColor\}/,
  highlightColor: /\$\{highlightColor\}/,
  serializedNewline: /\\n/g,
}

const state = {
  nodes: [],
  clusters: [],
  vectors: [],
  capturing: null, // fileName, clusterName, clusterItem, clusterItemDone, processingDone
  started: false,
}

const stateMachine = line => {
  if (state.capturing === 'processingDone') {
    return false
  }
  else if (state.capturing === null && state.started && RE.empty.test(line)) {
    return state.capturing = 'processingDone'
  }
  else if (state.capturing === null && !state.started && RE.fileName.test(line)) {
    return state.capturing = 'fileName'
  }
  else if (state.capturing === 'fileName' && RE.empty.test(line)) {
    return state.capturing = null
  }
  else if ([null, 'fileName'].includes(state.capturing) && !RE.empty.test(line)) {
    return state.capturing = 'clusterName'
  }
  else if (state.capturing === 'clusterName' && !RE.empty.test(line)) {
    return state.capturing = 'clusterItem'
  }
  else if (state.capturing === 'clusterItem' && RE.empty.test(line)) {
    return state.capturing = 'clusterItemDone'
  }
  else if (state.capturing === 'clusterItemDone' && RE.empty.test(line)) {
    return state.capturing = null
  }
  state.started = true
}

const templates = {
cluster: '  subgraph cluster_${clusterNameToken} {\n'
+ '    fontname="Press Start 2P"\n'
+ '    label="${clusterName}";\n'
+ '    fillcolor="${fillcolor}:white";\n'
+ '    shape=component;\n'
+ '    style=filled;\n'
+ '    gradientangle=45;\n'
+ '    penwidth=3;\n'
+ '${nodeNamesToken}\n'
+ '  }',

digraph: 'digraph {\n'
+ '\n'
+ '  fontname="Courier"\n'
+ '  compound=true\n'
+ '\n'
+ '  {\n'
+ ' node [ shape=component style=filled fillcolor=white penwidth=3 width=3]\n'
+ '${nodes}'
+ '  }\n'
+ '\n\n'
+ '${clusters}'
+ '\n\n'
+ '${vectors}'
+ '\n\n'
+ '}\n',
  
item: '  ${nodeNameToken} [ label=<<font color="${textColor}" face="Futura">${formattedContentToken}</font>> ];',
xitem: '  ${nodeNameToken} [ label=<<font color="${textColor}" face="Futura">${formattedContentToken}</font>>, fillcolor="${fillcolor}:white" ];',
xitem: '  ${nodeNameToken} [ label=<<font face="Futura">${formattedContentToken}</font>>, style=outline, color="${fillcolor}", penwidth=5 ];',
clusterTailHead: ' [ltail=${sourceClusterName}, lhead=${destinationClusterName}]',
vector: ' -> ${nodeNameToken}',
constraint: ' [constraint=false]',
nodeInCluster: '    ${nodeNameToken};',
  
}

function isColorTooDark(bgColor) {
  var color = (bgColor.charAt(0) === '#') ? bgColor.substring(1, 7) : bgColor;
  var r = parseInt(color.substring(0, 2), 16); // hexToR
  var g = parseInt(color.substring(2, 4), 16); // hexToG
  var b = parseInt(color.substring(4, 6), 16); // hexToB
  const chk = ((r * 0.299) + (g * 0.587) + (b * 0.114))
  const isBackgroundTooDark = (chk <= 100.0)
  // const isBackgroundTooDark = (chk > 100.0)
// console.log(">>>dcv (generate-card-dependencies-graph.js, , chk:101)", chk, isBackgroundTooDark)
  return isBackgroundTooDark
  // return (chk > 186.0) ? darkColor : lightColor;
}

function pickTextColorBasedOnBgColorSimple(bgColor, lightColor="#FFFFFF", darkColor="#000000") {
  return isColorTooDark(bgColor) ? lightColor : darkColor;
}

function pickTextColorBasedOnBgColorAdvanced(bgColor, lightColor="#FFFFFF", darkColor="#000000") {
  var color = (bgColor.charAt(0) === '#') ? bgColor.substring(1, 7) : bgColor;
  var r = parseInt(color.substring(0, 2), 16); // hexToR
  var g = parseInt(color.substring(2, 4), 16); // hexToG
  var b = parseInt(color.substring(4, 6), 16); // hexToB
  var uicolors = [r / 255, g / 255, b / 255];
  var c = uicolors.map((col) => {
    if (col <= 0.03928) {
      return col / 12.92;
    }
    return Math.pow((col + 0.055) / 1.055, 2.4);
  });
  var L = (0.2126 * c[0]) + (0.7152 * c[1]) + (0.0722 * c[2]);
  return (L > 0.179) ? darkColor : lightColor;
}

const getRandomColor = () => {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }

  if (isColorTooDark(color)) return getRandomColor()
  return color
}

const wrapString = (line, length) => {
  const words = line.split(RE.spaces)
  return words.reduce((lines, word, index) => {
    const lineLength = lines[lines.length-1].length + word.length
    lines[lines.length-1] += ((lines[lines.length-1].length > 0) ? ` ${word}` : word)
    if (lineLength > length) lines.push('')
    return lines
  }, [''])
}

const formatClusterItem = (line, {nodeName, fillColor, textColor, highlightColor}) => {
  const formattedContentToken = 
    ((wrapString(line, WRAP_MIN) || []).join('<br/>'))
    .replaceAll(RE.highlightedToken, `<font color="${highlightColor}">$1</font>`)

  return templates.item
    .replace(RE.nodeNameToken, nodeName)
    .replace(RE.formattedContentToken, formattedContentToken)
    .replace(RE.fillcolor, fillColor)
    .replace(RE.textColor, textColor)
}

const addClusterItem = (line) => {
  const isDirectionalLine = RE.directionalLine.test(line)
  if (isDirectionalLine) line = line.replace(RE.directionalLine, '')

  const currentCluster = state.clusters[state.clusters.length-1]
  const index = (currentCluster.items.length).toString().padStart(2, '0')
  const indexPrefix = currentCluster.name.replaceAll(RE.nonAlphaNumeric, '_')

  const nodeName = `node_${indexPrefix}_${index}`
  const currentItem = formatClusterItem(line, {
    nodeName, fillColor: currentCluster.fillColor,
    textColor: currentCluster.textColor,
    highlightColor: currentCluster.highlightColor,
  })

// - [FE] Architect solution to pull oauth credentials/config from {cf vcap json config service}
  
  // auth_01 [ label = <<font face="Futura">Architect solution to<br/> pull oauth credentials/config<br/> from <font color="red">cf vcap json config</font><br/> service</font>> ];
  
  state.nodes.push({name: nodeName, block: currentItem})
  currentCluster.items.push({name: nodeName})

  const clusterIndex = state.clusters.length-1
  if (!state.vectors[clusterIndex]) state.vectors[clusterIndex] = []

  if (isDirectionalLine) state.vectors[clusterIndex].push({type: "point", name: nodeName, clusterName: `cluster_${currentCluster.clusterName}`})
}

const generateGraph = (digraph, fileName) => {
  // credit: https://stackabuse.com/executing-shell-commands-with-node-js/
  return new Promise((resolve, reject) => {
    exec(`cat << EOL | dot -Tpng > "${fileName}"; open "${fileName}"
${digraph}
EOL`, (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return reject(error);
        }
        return resolve()
    });
  })
}

input.on('data', line => {
  stateMachine(line)

  if (state.capturing === 'processingDone') return false

  if (state.capturing === 'fileName') {
    state.fileName = line
      .replace(RE.fileName, '$1')
      .replace(RE.nonAlphaNumeric, '-')
      .replace(RE.end, '.png')
  }
  else if (state.capturing === 'clusterName') {
    const clusterName = line.replaceAll(RE.nonAlphaNumeric, '_')
    const fillColor = getRandomColor()
    const textColor = pickTextColorBasedOnBgColorSimple(fillColor)
    const highlightColor = pickTextColorBasedOnBgColorSimple(fillColor, "yellow", "red")
    
    state.clusters.push({clusterName, name: line, items: [], fillColor, textColor, highlightColor})
  }
  else if (state.capturing === 'clusterItem') addClusterItem(line)
  else if (state.capturing === 'clusterItemDone') {
    const currentCluster = state.clusters[state.clusters.length-1]

    const clusterNodeNames = currentCluster.items.map(item => templates.nodeInCluster.replace(RE.nodeNameToken, item.name))

    currentCluster.block = templates.cluster
      .replace(RE.clusterNameToken, currentCluster.clusterName)
      .replace(RE.clusterName, currentCluster.name)
      .replace(RE.fillcolor, currentCluster.fillColor)
      .replace(RE.nodeNamesToken, clusterNodeNames.join('\n'))

    stateMachine(line)
  }

  // state.lines.push(line)
});

input.on('end', async () => {
  state.vectors = state.vectors.reduce((vectors, vectorNodes, index) => {
    if (state.vectors.length > 1 && index > 0) {
      const lastVectorNodes = vectors[vectors.length-1].values
      const [sourceNode, destinationNode] = [lastVectorNodes[0], vectorNodes[0]]
      const clusterVector = [sourceNode, destinationNode, {clusterTailHead: true}]

      const clusterTailHead = templates.clusterTailHead
        .replace(RE.sourceClusterName, sourceNode.clusterName)
        .replace(RE.destinationClusterName, destinationNode.clusterName)
      
      const block = `${[sourceNode.name, destinationNode.name].join(" -> ")}${clusterTailHead}`
      vectors.push({values: clusterVector, block})
    }

    const block = `${vectorNodes.map(entry => entry.name).join(" -> ")}${templates.constraint}`
    vectors.push({values: [...vectorNodes, {constraint: false}], block})
    
    return vectors
  }, [])

  const digraph = templates.digraph
    .replace(RE.nodes, state.nodes.map(entry => entry.block).join('\n'))
    .replace(RE.clusters, state.clusters.map(entry => entry.block).join('\n'))
    .replace(RE.vectors, state.vectors.map(entry => entry.block).join('\n'))

  // console.log(JSON.stringify(state.vectors, null, 2))

  if (GENERATE_CODE) {
    console.log(digraph)
  } else {
    try {
      await generateGraph(digraph, state.fileName)
      console.log(state.fileName)
    } catch(err) {
      console.log(">>>dcv (generate-card-dependencies-graph.js, , err:225)", err)
    }
  }
})

input.on('error', error => {
  console.error('Error', error)
})

/*

cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | /Users/dcvezzani/scripts/generate-card-dependencies-graph.js

cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | WRAP_MIN=13 /Users/dcvezzani/scripts/generate-card-dependencies-graph.js | dot -Tpng > card-dependencies.png; open card-dependencies.png


cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | GENERATE_CODE=true ~/scripts/generate-card-dependencies-graph.js

*/
