#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const { JSDOM } = require('jsdom');

async function main() {
  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  const dom = new JSDOM(data.toString())
  const document = dom.window.document
  

  process.stdout.write(document.querySelector('form.js-add-team-member-form input[name="authenticity_token"]').value)
}

main();
