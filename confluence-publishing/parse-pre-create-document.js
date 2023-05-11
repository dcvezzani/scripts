#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const { JSDOM } = require('jsdom');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {baseUrl: process.argv[2], title: process.argv[3], links: []}

input.on('data', data => {
  if (!state.contentId) {
    const dom = new JSDOM(data.toString())
    dom.reconfigure({ url: state.baseUrl });
    
    const document = dom.window.document

    const getData = (meta) => {
      return meta?.getAttribute('content')
    }

    state.contentId = getData(document.querySelector('meta[name="ajs-attachment-source-content-id"]'))
    // <meta name="ajs-attachment-source-content-id" content="145851448">
  }
});

input.on('end', () => {
  return console.log(JSON.stringify({contentId: state.contentId}))
});

input.on('error', e => {
  console.error(e)
});

