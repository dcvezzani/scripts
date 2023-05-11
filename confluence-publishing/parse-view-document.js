#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const { JSDOM } = require('jsdom');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {baseUrl: process.argv[2]}

input.on('data', data => {
  if (!state.editLinkUrl) {
    const dom = new JSDOM(data.toString())
    dom.reconfigure({ url: state.baseUrl });
    
    const document = dom.window.document
    const anchor = document.querySelector('#editPageLink')

    const getData = (anchor) => {
      return {url: anchor?.getAttribute('href'), fullUrl: `${document.location.origin}${anchor?.getAttribute('href')}`}
    }

    state.editLinkUrl = getData(anchor)
  }
});

input.on('end', () => {
  return console.log(JSON.stringify({editLinkUrl: state.editLinkUrl}))
});

input.on('error', e => {
  console.error(e)
});





