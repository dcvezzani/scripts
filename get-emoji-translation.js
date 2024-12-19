#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// const cookie = '_ga=GA1.1.271215131.1721132550; __gads=ID=14f8ac822726c71e:T=1721132549:RT=1721132549:S=ALNI_MY8ooIZIHhlvpf83BYIxCrumulexg; __gpi=UID=00000e84082acda6:T=1721132549:RT=1721132549:S=ALNI_Maza-8BAz00UIBvFOS_pmBmLTSqjw; __eoi=ID=5ef59e7ce9c63bae:T=1721132550:RT=1721132550:S=AA-AfjZnt6IdSRQoKC8Scn4wMNuB; FCNEC=%5B%5B%22AKsRol8w1jCIvqvUWeaIQFJPM7i_gMPxhMyjBiALQmMT4kSBLeDOg-_KEIYkkU-Bvwe7GErDX6x9iWjZTyO8kndGqLZvByvpmjPz5zCD0t16g1nxQ67XDlJmsTj7AliofIMYDXw5IBzgXb6HZ4v7EKBZvmB-SOUCAg%3D%3D%22%5D%5D; _ga_EXWRQR2DTQ=GS1.1.1721132549.1.0.1721132558.0.0.0'

const fetch = (...args) => import('node-fetch/src/index.js').then(({default: fetch}) => fetch(...args))

const RE = {
  empty: /^$/,
  end: /$/,
  processingDone: /^END$/,
  serializedNewline: /\\n/g,
  token: (tokenName, ...flags) => new RegExp(`\\$\\{${tokenName}Token\\}`, ...flags),
}

const state = {
  lines: [],
  started: false,
  paused: false,
  capturing: null, // indicates which blocks are being processed
}

const stateMachine = line => {
  state.paused = (state.capturing !== null && state.started && RE.empty.test(line))

  if (state.capturing === 'processingDone') {
    return false
  }
  else if (state.started && RE.processingDone.test(line)) {
    return state.capturing = 'processingDone'
  }

  state.started = true
  // process transitions

  if (state.started && RE.empty.test(line)) {
    state.paused = false
    // start processing next list entry (if applicable)
  }
}

let templates = {
digraph: 'digraph {\n'
+ '  fontname="Courier";\n'
+ '  compound=true;\n'
+ '  labeljust=l;\n'
+ '\n'
+ '${sectionsToken}'
+ '}\n',
}

const getEmojiTranslations = async (lines=[]) => {
  try {
    const promises = lines.map(line => getEmojiTranslation(line))
    const payload = await Promise.all(promises)
    return process.stdout.write(payload.join("\n"));
  } catch(error) {
    throw error;
  }
}

const getEmojiTranslation = async (line) => {
  try {
    const body = `text=${escape(line)}&lang=en&public=1`;

    const response = await fetch("https://www.emojiall.com/en/text-to-emoji", {
      "headers": {
        "accept": "application/json, text/javascript, */*; q=0.01",
        "accept-language": "en-US,en;q=0.9",
        "cache-control": "no-cache",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "pragma": "no-cache",
        "priority": "u=1, i",
        "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Google Chrome\";v=\"126\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-requested-with": "XMLHttpRequest",
        // cookie,
      },
      "referrer": "https://www.emojiall.com/en/emoji-translator-page",
      "referrerPolicy": "strict-origin-when-cross-origin",
      body,
      "method": "POST",
      "mode": "cors",
      "credentials": "include"
    });

    if (response.ok) {
      const json = await response.json();
      const payload = unescape(json.created.output);
      return payload;
    }

    throw `Bad response code`;
  } catch(error) {
    console.error(">>>dcv (get-emoji-translation.js, , 'Unable to fetch emoji translation':93)", 'Unable to fetch emoji translation')
    throw error;
  }
};


if (process.argv.length > 2) {
  // use process args
  getEmojiTranslations(process.argv.slice(2));
} else {
  // assume pipe is used
  const split = require('split');
  const input = process.stdin.pipe(split());
  const output = process.stdout;

  /* ======================================= */
  input.on('data', line => {
    // stateMachine(line)
    // if (state.paused || state.capturing === 'processingDone') return false

    // state.lines.push(`${(state.paused) ? null : state.capturing}: ${line}; (${RE.empty.test(line)}, ${state.paused})`)
    if (line?.length > 0) state.lines.push(line)
  });
      
  /* ======================================= */
  input.on('end', async () => {
    // console.log(">>>dcv (get-emoji-translation.js, cat: scripts/get-emoji-translation.js: state.lines:52)", state.lines)
    getEmojiTranslations(state.lines)
  })

  /* ======================================= */
  input.on('error', error => {
    console.error('Error', error)
  })
}

/*

/Users/dcvezzani/scripts/get-emoji-translation.js 'Awesome!!' 'fast car'

cat << EOL | /Users/dcvezzani/scripts/get-emoji-translation.js
Awesome!!
fast car
EOL

*/

