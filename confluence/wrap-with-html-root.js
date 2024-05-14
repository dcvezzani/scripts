#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

async function main() {
  let data = "";
  for await (const chunk of process.stdin) data += chunk;
  process.stdout.write(`<html>${data.toString()}</html>`)
}

main();


