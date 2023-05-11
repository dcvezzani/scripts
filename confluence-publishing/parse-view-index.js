#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const { JSDOM } = require('jsdom');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {baseUrl: process.argv[2], title: process.argv[3], links: []}

input.on('data', data => {
  const dom = new JSDOM(data.toString())
  dom.reconfigure({ url: state.baseUrl });
  
  const document = dom.window.document

  const getData = (anchor) => {
    const url = anchor.getAttribute('href')
    const urlParts = url.split(/\//) || ['n/a']
    return {text: anchor.textContent, url, name: urlParts[urlParts.length-1], fullUrl: `${document.location.origin}${anchor.getAttribute('href')}`}
  }

  if (!!state.title) {
    const anchor = Array.from(document.querySelectorAll('#main-content > ul > li > a')).find(anchor => anchor.textContent === state.title)
    if (anchor) state.links.push(getData(anchor))
  } else {
    state.links = Array.from(document.querySelectorAll('#main-content > ul > li > a')).map(anchor => getData(anchor))
  }
});

input.on('end', () => {
  return console.log(JSON.stringify(state.links))
  // return (!!state.title) ? console.log(JSON.stringify(state.links)) : state.links[0].fullUrl
});

input.on('error', e => {
  console.error(e)
});




