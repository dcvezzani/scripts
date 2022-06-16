#!/usr/bin/env node

// const xml2js = require('/Users/dcvezzani/.nvm/versions/node/v16.10.0/lib/node_modules/xml2js/lib/xml2js.js');
const xml2js = require('xml2js');

process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('data', function(data) {

xml2js.parseString(data, (err, result) => {
    if(err) {
        throw err;
    }

    // `result` is a JavaScript object
    // convert it to a JSON string
    const json = JSON.stringify(result, null, 4);

    // log JSON string
    console.log(json);
    
});
  
});

