#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const { exec } = require("child_process");

const WRAP_MIN = process.env.WRAP_MIN || 20
const GENERATE_CODE = (process.env.GENERATE_CODE === 'true')

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  empty: /^$/,
  end: /$/,
  processingDone: /^END$/,
  groupTitle: /^# +(.+) *$/,
  useCaseTitle: /^## +(.+) *$/,
  useCaseSectionTitle: /^### +(.+) *$/,
  directionalLine: /^- /,
  indexToken: /\$\{index\}/,
  nodeNameToken: /\$\{nodeNameToken\}/,
  nodeGroupToken: /\$\{nodeGroupToken\}/,
  genericToken: /(?<=\$\{)([^\}]+)(?=Token\})/g,
  nodeNameText: /\$\{nodeNameText\}/,
  formattedContentToken: /\$\{formattedContentToken\}/,
  clusterNameToken: /\$\{clusterNameToken\}/,
  clusterName: /\$\{clusterName\}/,
  nodeNamesToken: /\$\{nodeNamesToken\}/,
  rowsContentToken: /\$\{rowsContentToken\}/,
  lineContentToken: /\$\{lineContentToken\}/,
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
  token: (tokenName, ...flags) => new RegExp(`\\$\\{${tokenName}Token\\}`, ...flags),
}

const state = {
  lines: [],
  node: {
    title: null,
    body: [],
  },
  section: {
    nodes: [],
    subgraph: {},
    vectors: []
  },
  currentNode: null,
  currentSection: null,
  currentSectionIndex: null,
  groupTitle: null,
  sections: [], // nodes
  capturing: null, // groupTitle, clusterName, clusterItem, clusterItemDone, processingDone
  started: false,
  paused: false,
}

const stateMachine = line => {
  // if (state.capturing !== null && state.started && RE.empty.test(line)) return state.paused = true
  // state.paused = false
  state.paused = (state.capturing !== null && state.started && RE.empty.test(line))

  if (state.capturing === 'processingDone') {
    return false
  }
  else if (state.started && RE.processingDone.test(line)) {
    return state.capturing = 'processingDone'
  }

  state.started = true
  if (RE.groupTitle.test(line)) {
    return state.capturing = 'groupTitle'
  }
  else if (['groupTitle', 'useCaseSectionDone'].includes(state.capturing) && RE.useCaseTitle.test(line)) {
    return state.capturing = 'useCaseTitle'
  }
  else if (['useCaseTitle', 'useCaseSectionDone'].includes(state.capturing) && RE.useCaseSectionTitle.test(line)) {
    return state.capturing = 'useCaseSectionTitle'
  }
  else if (state.capturing === 'useCaseSectionLine' && RE.empty.test(line)) {
    state.paused = false
    return state.capturing = 'useCaseSectionDone'
  }
  else if (state.capturing === 'useCaseSectionTitle') {
    return state.capturing = 'useCaseSectionLine'
  }
}

let templates = {
cluster: '  subgraph cluster_${clusterNameToken} {\n'
+ '    fontname="Press Start 2P"\n'
+ '    label="${clusterLabelToken}";\n'
+ '    fillcolor="${fillcolor}:white";\n'
+ '    shape=component;\n'
+ '    style=filled;\n'
+ '    gradientangle=80;\n'
+ '    penwidth=3;\n'
+ '\n'
+ '    subgraph cluster_${clusterNameToken}_00 {\n'
+ '      label="";\n'
+ '      fillcolor="transparent";\n'
+ '      shape=plain;\n'
+ '      style=invis;\n'
+ '      gradientangle=0;\n'
+ '      penwidth=0;\n'
+ '\n'
+ '${nodeNamesToken}'
+ '    }\n'
+ '  }\n',
  
node: '    node_${nodeNameToken} [ label=<\n'
+ '      <table border="0" cellborder="0" cellpadding="3" cellspacing="0"> \n'
+ '        <tr> <td colspan="2" align="left"><font color="#000000" face="Futura"><b>${nodeNameText}</b><br align="left" /></font></td> </tr> \n'
+ '\n'
+ '${rowsContentToken}'
+ '      </table> \n'
+ '    >];\n',

nodeLine: '        <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">${lineContentToken}</td> </tr>\n',

nodeLineBreak: '<br align="left" />',

nodeName: 'node_${nodeNameToken}',

nodeListArrow: ' -> ',

nodeList: '  ${nodeLinkedListToken} [constraint=false];\n',

nodeHorizontalList: '  ${nodeLinkedListToken} [color=invis];\n',

section: '  {\n'
+ '    node [ shape=component style=filled fillcolor=white penwidth=3 width=3];\n'
+ '\n'
+ '${nodesToken}'
+ '  }\n'
+ '\n'
+ '${clustersToken}'
+ '\n'
+ '${vectorsToken}'
+ '\n',
  
digraph: 'digraph {\n'
+ '  fontname="Courier";\n'
+ '  compound=true;\n'
+ '  labeljust=l;\n'
+ '\n'
+ '${sectionsToken}'
+ '}\n',
  
constraint: ' [constraint=false]',
}

/* ======================================= */
templates = {
  ...templates,
  nodeNameDecl: `      ${templates.nodeName};\n`,
}

/* ======================================= */
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

/* ======================================= */
function pickTextColorBasedOnBgColorSimple(bgColor, lightColor="#FFFFFF", darkColor="#000000") {
  return isColorTooDark(bgColor) ? lightColor : darkColor;
}

/* ======================================= */
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

/* ======================================= */
const getRandomColor = () => {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }

  if (isColorTooDark(color)) return getRandomColor()
  return color
}

/* ======================================= */
const wrapString = (line, length) => {
  const words = line.split(RE.spaces)
  return words.reduce((lines, word, index) => {
    const lineLength = lines[lines.length-1].length + word.length
    lines[lines.length-1] += ((lines[lines.length-1].length > 0) ? ` ${word}` : word)
    if (lineLength > length) lines.push('')
    return lines
  }, [''])
}

/* ======================================= */
const serializeCluster = (section) => {
  const reNodeName = RE.token('nodeName')
  const nodeNames = section.nodes.map(node => templates.nodeNameDecl.replace(reNodeName, node.nodeId)).join("")

  const reClusterName = RE.token('clusterName', 'g')
  const reClusterLabel = RE.token('clusterLabel')
  const reNodeNames = RE.token('nodeNames')
  return templates.cluster
  .replaceAll(reClusterName, section.subgraph.clusterNameToken)
  .replace(reClusterLabel, section.subgraph.clusterLabel)
  .replace(reNodeNames, nodeNames)
  .replace(RE.fillcolor, section.subgraph.fillcolor)
}

/* ======================================= */
const serializeNodes = (section) => {
  return section.nodes.map(node => node.dot).join("")
}

/* ======================================= */
const serializeVectors = (section) => {
  const reNodeName = RE.token('nodeName')
  const nodeNames = section.nodes.map(node => templates.nodeName.replace(reNodeName, node.nodeId))

  const reNodeLinkedList = RE.token('nodeLinkedList')
  const vectors = [
    templates.nodeList
    .replace(reNodeLinkedList, nodeNames.join(templates.nodeListArrow))
  ]

  if (state.currentSectionIndex > 0) {
    const previousSection = state.sections[state.currentSectionIndex-1]
    const firstNodeNameFromPreviousSection = templates.nodeName.replace(reNodeName, previousSection.nodes[0].nodeId)
    const firstNodeNameFromCurrentSection = nodeNames[0]

    const nodeHorizontalList = templates.nodeHorizontalList
    .replace(reNodeLinkedList, [
      firstNodeNameFromPreviousSection,
      firstNodeNameFromCurrentSection,
    ].join(templates.nodeListArrow))

    vectors.push(nodeHorizontalList)
  }

  return vectors.join("")
}

/* ======================================= */
const serializeCase = (section) => {
  const tokens = templates.section.match(RE.genericToken)

  return tokens.reduce((sectionDot, tokenName) => {
    let value = null
    switch(tokenName) {
      case 'nodes': {
        value = serializeNodes(section)
        break;
      }
      case 'clusters': {
        value = serializeCluster(section)
        break;
      }
      case 'vectors': {
        value = serializeVectors(section)
        break;
      }
    }

    return (value && sectionDot.replaceAll(RE.token(tokenName, 'g'), value)) || sectionDot
  }, templates.section)
}

/* ======================================= */
const serializeDigraph = () => {
  const reSections = RE.token('sections')
  return templates.digraph
  .replace(reSections, state.sections.map(section => section.dot).join(""))
}

/* ======================================= */
const setCurrentSection = (sectionIndex) => {
  state.currentSection = state.sections[state.sections.length-1]
  state.currentSectionIndex = state.sections.length-1
}

/* ======================================= */
const createNewSection = () => {
  state.sections.push(JSON.parse(JSON.stringify(state.section)))
  setCurrentSection(state.sections.length-1)
}

/* ======================================= */
input.on('data', line => {
  stateMachine(line)

  if (state.paused || state.capturing === 'processingDone') return false

  // groupTitle, useCaseTitle, useCaseSectionTitle, useCaseSectionLine, useCaseSectionDone, processingDone
  
  if (state.capturing === 'groupTitle') {
    state.filename = line
      .replace(RE.groupTitle, '$1')
      .replace(RE.nonAlphaNumeric, '-')
      .replace(RE.end, '.png')
  }
  else if (state.capturing === 'useCaseTitle') {

    if (!!state.currentSection) {
      state.currentSection.dot = serializeCase(state.currentSection)
    }
    
    createNewSection()

    state.currentSection.subgraph.clusterLabel = line
      .replace(RE.useCaseTitle, '$1')

    state.currentSection.subgraph.clusterNameToken = state.currentSection.subgraph.clusterLabel
      .replace(RE.nonAlphaNumeric, '_')
      .trim()
      .toLowerCase()

    state.currentSection.subgraph.fillcolor = getRandomColor()

    // nodenamestoken
  }
  else if (state.capturing === 'useCaseSectionTitle') {
    state.currentSection.nodes.push(JSON.parse(JSON.stringify(state.node)))
    state.currentNode = state.currentSection.nodes[state.currentSection.nodes.length-1]

    state.currentNode.title = line
      .replace(RE.useCaseSectionTitle, '$1')
  }
  else if (state.capturing === 'useCaseSectionLine') {
    const highlightColor = pickTextColorBasedOnBgColorSimple(state.currentSection.subgraph.fillcolor, "yellow", "red")
    const wrappedLines = [...(wrapString(line, WRAP_MIN) || []), '']
    const formattedLine = 
      (wrappedLines.join(templates.nodeLineBreak))
      .replaceAll(RE.highlightedToken, `<font color="${highlightColor}">$1</font>`)

    const nodeLine = templates.nodeLine
      .replace(RE.lineContentToken, formattedLine)

    state.currentNode.body.push(nodeLine)
    
    const nodeIndex = `${state.currentSection.nodes.length}`.padStart(2, '0')
    state.currentNode.nodeId = `${state.currentSection.subgraph.clusterNameToken}_${nodeIndex}`
  }
  else if (state.capturing === 'useCaseSectionDone') {
    state.currentNode.dot = templates.node
    .replace(RE.nodeNameToken, state.currentNode.nodeId)
    .replace(RE.nodeNameText, state.currentNode.title)
    .replace(RE.rowsContentToken, state.currentNode.body.join(""))
  }

  state.lines.push(`${(state.paused) ? null : state.capturing}: ${line}; (${RE.empty.test(line)}, ${state.paused})`)
});

/* ======================================= */
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

/* ======================================= */
input.on('end', async () => {
  if (!!state.currentSection) {
    state.currentSection.dot = serializeCase(state.currentSection)
  }

  const digraph = serializeDigraph()

  if (GENERATE_CODE) {
    console.log(digraph)
  } else {
    try {
      await generateGraph(digraph, state.filename)
      console.log(state.filename)
    } catch(err) {
      console.log(">>>dcv (generate-card-dependencies-graph.js, , err:225)", err)
    }
  }
})

/* ======================================= */
input.on('error', error => {
  console.error('Error', error)
})

/*

cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | /Users/dcvezzani/scripts/generate-card-dependencies-graph.js

cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | WRAP_MIN=13 /Users/dcvezzani/scripts/generate-card-dependencies-graph.js | dot -Tpng > card-dependencies.png; open card-dependencies.png

cat /Users/dcvezzani/Dropbox/journal/current/20240624-arp-oauth-card-dependencies.md | GENERATE_CODE=true ~/scripts/generate-card-dependencies-graph.js


cat /Users/dcvezzani/Dropbox/journal/current/20240711-use-cases.md | /Users/dcvezzani/scripts/generate-use-case.js


cat /Users/dcvezzani/Dropbox/journal/current/20240712-asdf.dot | dot -Tpng > asdf.png; open asdf.png
cat /Users/dcvezzani/Dropbox/journal/current/20240712-asdf-02.dot | dot -Tpng > asdf.png; open asdf.png

*/
