#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// abandoned for now

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

let lines = []
let inblock = false
const reduce = (line) => {
  if (line.length > 0) {
    if (line.startsWith('```')) inblock = !inblock
    
    if (inblock) {
      line = line.replaceAll(/</g, '&lt;')
    }
    lines.push(line)
  }
}


input.on('data', line => {
  reduce(line)
});

input.on('end', () => {
  console.log(lines.join("\n"))
});

input.on('error', e => {
  console.error(e)
});

/*

/Users/dcvezzani/scripts/developer-notes.sh B87A60EBF55B57F7F3AF42563024FB0D /Users/dcvezzani/Dropbox/journal/current/20201110-transform-basics.md
cat /Users/dcvezzani/Dropbox/journal/current/20201110-transform-basics.md | /Users/dcvezzani/scripts/developer-notes-escape-code-blocks.js



 * */
