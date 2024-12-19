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
  templates: {
    group: {
      type: 'group',
      id: null,
      title: null,
      filename: null,
      useCases: [],
    },
    useCase: {
      type: 'useCase',
      title: null,
      useCaseSections: [],
    },
    useCaseSection: {
      type: 'useCaseSection',
      title: null,
      lines: [],
    },
    useCaseLine: {
      type: 'useCaseLine',
      value: null,
    },
  },

  lines: [],
  group: {},
  useCases: [],

  current: {
    useCase: null,
    useCaseSection: null,
  },

  capturing: null, // groupTitle, clusterName, clusterItem, clusterItemDone, processingDone
  started: false,
  paused: false,
  finished: false,
}

const stateMachine = line => {
  // if (state.capturing !== null && state.started && RE.empty.test(line)) return state.paused = true
  // state.paused = false
  state.paused = (state.capturing !== null && state.started && RE.empty.test(line))

  if (state.capturing === 'processingDone') {
    state.finished = true
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
digraph: 
+ 'digraph {\n'
+ '  fontname="Courier";\n'
+ '  compound=true;\n'
+ '  labeljust=l;\n'
+ '\n'
+ '  graph [\n'
+ '    rankdir=LR\n'
+ '  ];\n'
+ '\n'
+ '  {\n'
+ '    node [ shape=component style=filled fillcolor=white penwidth=3 width=3 ];\n'
+ '\n'
+ '    subgraph cluster_use_case_1_t {\n'
+ '      label="" \n'
+ '      penwidth=3;\n'
+ '      fillcolor="#B45A23:white";\n'
+ '      style=filled;\n'
+ '      gradientangle=80;\n'
+ '\n'
+ '      subgraph cluster_use_case_1_g {\n'
+ '      fontname="Press Start 2P"\n'
+ '      penwidth=0;\n'
+ '      label="Use case 1" \n'
+ '      fillcolor="transparent";\n'
+ '\n'
+ '      subgraph cluster_use_case_1_01_g {\n'
+ '        label="";\n'
+ '        fillcolor="transparent";\n'
+ '        shape=plain;\n'
+ '        style=invis;\n'
+ '        gradientangle=0;\n'
+ '        penwidth=0;\n'
+ '        rankdir=TB\n'
+ '\n'
+ '      node_use_case_1_01 [ label=<\n'
+ '        <table border="0" cellborder="0" cellpadding="3" cellspacing="0"> \n'
+ '          <tr> <td colspan="2" align="left"><font color="#000000" face="Futura"><b>assuming</b><br align="left" /></font></td> </tr> \n'
+ '\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">You can bend rivers<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">But when I get home, the<br align="left" />only thing I have power<br align="left" />over is the garbage<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">Let&pos;s do it again then,<br align="left" />what the heck<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">Only God can make a tree<br align="left" />- but you can paint one<br align="left" /><br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">We might as well make some<br align="left" />Almighty mountains today<br align="left" />as well, what the heck.<br align="left" /><br align="left" /></td> </tr>\n'
+ '        </table> \n'
+ '      >];\n'
+ '\n'
+ '      node_use_case_1_01_00 [label="" shape=circle fixedsize=shape width=0 height=0 color=invis];\n'
+ '\n'
+ '      }\n'
+ '\n'
+ '\n'
+ '      subgraph cluster_use_case_1_02_g {\n'
+ '        label="";\n'
+ '        fillcolor="transparent";\n'
+ '        shape=plain;\n'
+ '        style=invis;\n'
+ '        gradientangle=0;\n'
+ '        penwidth=0;\n'
+ '        rankdir=TB\n'
+ '\n'
+ '      node_use_case_1_02 [ label=<\n'
+ '        <table border="0" cellborder="0" cellpadding="3" cellspacing="0"> \n'
+ '          <tr> <td colspan="2" align="left"><font color="#000000" face="Futura"><b>when</b><br align="left" /></font></td> </tr> \n'
+ '\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">This piece of canvas is<br align="left" />your world<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">The shadows are just like<br align="left" />the highlights, but we&pos;re<br align="left" />going in the opposite direction<br align="left" /><br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">This is a happy place,<br align="left" />little squirrels live here<br align="left" />and play<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">What the devil<br align="left" /></td> </tr>\n'
+ '        </table> \n'
+ '      >];\n'
+ '\n'
+ '      node_use_case_1_02_00 [label="" shape=circle fixedsize=shape width=0 height=0 color=invis];\n'
+ '\n'
+ '      }\n'
+ '\n'
+ '      subgraph cluster_use_case_1_03_g {\n'
+ '        label="";\n'
+ '        fillcolor="transparent";\n'
+ '        shape=plain;\n'
+ '        style=invis;\n'
+ '        gradientangle=0;\n'
+ '        penwidth=0;\n'
+ '        rankdir=TB\n'
+ '\n'
+ '      node_use_case_1_03 [ label=<\n'
+ '        <table border="0" cellborder="0" cellpadding="3" cellspacing="0"> \n'
+ '          <tr> <td colspan="2" align="left"><font color="#000000" face="Futura"><b>then</b><br align="left" /></font></td> </tr> \n'
+ '\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">I sincerely wish for you<br align="left" />every possible joy life<br align="left" />could bring<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">This painting comes right<br align="left" />out of your heart<br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">You have to allow the paint<br align="left" />to break to make it beautiful<br align="left" /><br align="left" /></td> </tr>\n'
+ '          <tr> <td width="15px" valign="top" align="right">-</td> <td align="left">But we&pos;re not there yet,<br align="left" />so we don&pos;t need to worry<br align="left" />about it<br align="left" /></td> </tr>\n'
+ '        </table> \n'
+ '      >];\n'
+ '\n'
+ '      node_use_case_1_03_00 [label="" shape=circle fixedsize=shape width=0 height=0 color=invis];\n'
+ '\n'
+ '      }\n'
+ '\n'
+ '      } // cluster_use_case_1_g\n'
+ '\n'
+ '    } // cluster_use_case_1_t\n'
+ '    \n'
+ '  }\n'
+ '\n'
+ 'node_use_case_1_01_00 -> node_use_case_1_02_00 -> node_use_case_1_03_00 [color=invis]\n'
+ 'node_use_case_1_01_00 -> node_use_case_1_01 [constraint=false color=invis]\n'
+ 'node_use_case_1_02_00 -> node_use_case_1_02 [constraint=false color=invis]\n'
+ 'node_use_case_1_03_00 -> node_use_case_1_03 [constraint=false color=invis]\n'
+ '  \n'
+ '\n'
+ '\n'
+ '}\n'
+ '\n'
+ '\n'
+ '\n',
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
const serializeDigraph = (node) => {
  const groups = '{groups}';

  return `  
digraph {
  fontname="Courier";
  compound=true;
  labeljust=l;

  graph [
    rankdir=LR
  ];

  ${groups}
}
`
}

/* ======================================= */
const serializeUseCase = (node) => {
  const clusters = '{clusters}';
  const connectors = '{connectors}';

  return `  {
    node [ shape=component style=filled fillcolor=white penwidth=3 width=3 ];

    subgraph cluster_${node.id}_t {
      label="" 
      penwidth=3;
      fillcolor="#B45A23:white";
      style=filled;
      gradientangle=80;

      subgraph cluster_${node.id}_g {
      fontname="Press Start 2P"
      penwidth=0;
      label="${node.title}" 
      fillcolor="transparent";

      ${clusters}

      } // cluster_${node.id}_g

    } // cluster_${node.id}_t
    
  }

  ${connectors}
`
}

/* ======================================= */
const serialize = (node) => {
  switch(node.type) {
    case 'group': {
      return serializeDigraph(node)
      return {
        title: node.title,
        sections: node.useCases.map(serialize),
      }
    }
    case 'useCase': {
      return serializeUseCase(node)
      return {
        title: node.title,
        sections: node.useCaseSections.map(serialize),
      }
    }
    case 'useCaseSection': {
      return serializeUseCaseSection(node)
      return {
        title: node.title,
        lines: node.lines.map(serialize),
      }
    }
    case 'useCaseLine': {
      return serializeUseCaseLine(node)
      return node.value
      break;
    }
  }
}

/* ======================================= */
input.on('data', line => {
  stateMachine(line)

  if (state.finished) return false
  else if (state.capturing === 'processingDone') {
    state.lines.push(`${(state.paused) ? null : state.capturing}: ${line}; (${RE.empty.test(line)}, ${state.paused})`)
    state.useCases.push(state.current.useCase);
    return false
  } else if (state.paused) return false

  // groupTitle, useCaseTitle, useCaseSectionTitle, useCaseSectionLine, useCaseSectionDone, processingDone
  
  if (state.capturing === 'groupTitle') {
    state.group = JSON.parse(JSON.stringify(state.templates.group))
    state.group.title = line
      .replace(RE.groupTitle, '$1')

    state.group.filename = state.group.title
      .replace(RE.nonAlphaNumeric, '-')
      .replace(RE.end, '.png')

    state.group.id = state.group.title
      .replace(RE.nonAlphaNumeric, '_')
      .toLowerCase()
  }
  else if (state.capturing === 'useCaseTitle') {
    if (!!state.current.useCase) {
      state.group.useCases.push(state.current.useCase);
    }
    state.current.useCase = JSON.parse(JSON.stringify(state.templates.useCase))

    state.current.useCase.title = line
      .replace(RE.useCaseTitle, '$1')
  }
  else if (state.capturing === 'useCaseSectionTitle') {
    state.current.useCaseSection = JSON.parse(JSON.stringify(state.templates.useCaseSection))

    state.current.useCaseSection.title = line
      .replace(RE.useCaseSectionTitle, '$1')
  }
  else if (state.capturing === 'useCaseSectionLine') {
    const useCaseLine = JSON.parse(JSON.stringify(state.templates.useCaseLine))
    state.current.useCaseSection.lines.push({...useCaseLine, value: line});
  }
  else if (state.capturing === 'useCaseSectionDone') {
      state.current.useCase.useCaseSections.push(state.current.useCaseSection);
  }

  state.lines.push(`${(state.paused) ? null : state.capturing}: ${line}; (${RE.empty.test(line)}, ${state.paused})`)
});

/* ======================================= */
input.on('end', async () => {



  // console.log(">>>dcv (generate-use-case-02.js, , trace 1:422)", state.lines)
  delete state.lines
  console.log(">>>dcv (generate-use-case-02.js, , trace 1:422)", JSON.stringify(state.group, null, 2))

  // console.log(">>>dcv (generate-use-case-02.js, , :406)", JSON.stringify(serialize(state.group), null, 2))
  console.log(">>>dcv (generate-use-case-02.js, , :406)", serialize(state.group))
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
