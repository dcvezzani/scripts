#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// import * as acorn from 'acorn';
// import optionalChaining from 'acorn-optional-chaining';
const acorn = require('acorn')
const optionalChaining = require('/Users/dcvezzani/.nvm/versions/node/v16.16.0/lib/node_modules/acorn-optional-chaining/dist/index')

// acorn.Parser.extend(optionalChaining).parse('a?.b?.c');

function parseCodeToJSON(code) {
  try {
    const ast = acorn.parse(code, { ecmaVersion: 2020, locations: true, ranges: true });
    return JSON.stringify(ast, null, 2);
  } catch(err) {
    return JSON.stringify([], null, 2);
  }
}

const split = require('split');
// const input = process.stdin.pipe(split());
const input = process.stdin;
const output = process.stdout;

const state = {json: null}

input.on('data', data => {
  state.json = parseCodeToJSON(data)
});

input.on('end', () => {
  return console.log(state.json)
});

input.on('error', e => {
  console.error(e)
});


