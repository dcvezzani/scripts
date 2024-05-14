#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const { JSDOM } = require('jsdom');

const get_atl_token = (document) => {
  let atl_token_node = document.querySelector('input[name="atl_token"]')
  if (!atl_token_node) atl_token_node = document.querySelector('meta[id="atlassian-token"]')

  const atl_token = atl_token_node?.getAttribute('value') || atl_token_node?.getAttribute('content')
  // const draftShareId = document.querySelector('meta[name="ajs-draft-share-id"]').getAttribute('content')

  return {atl_token}
}

const get_pageId = (document) => {
  let pageId_node = document.querySelector('meta[name="ajs-page-id"]')

  const pageId = pageId_node?.getAttribute('content')

  return {pageId}
}

const get_pageTitle = (document) => {
  let pageTitle_node = document.querySelector('meta[name="ajs-page-title"]')

  const pageTitle = pageTitle_node?.getAttribute('content')

  return {pageTitle}
}

async function main() {
  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  const dom = new JSDOM(data.toString())
  const document = dom.window.document
  
  // process.stderr.write(`>>> ${process.argv[2]}\n`)
  
  switch(process.argv[2]) {
    case 'draftId:draftShareId': {
      // <input id="draftId" type="hidden" name="draftId" value="163874302">
      // <input id="draftShareId" type="hidden" name="draftShareId" value="5623727c-0179-4903-bd23-b2b205689ab8">
      // /Users/dcvezzani/scripts/confluence/get-atlassian-token.js 'draftId:draftShareId'
      const draftId = document.querySelector('input[id="draftId"]').getAttribute('value')
      const draftShareId = document.querySelector('input[id="draftShareId"]').getAttribute('value')
      process.stdout.write(JSON.stringify({draftId,draftShareId}))
      break;
    }

    case 'draftId': {
      // <meta name="ajs-draft-id" content="163874303">
      // <meta name="ajs-draft-share-id" content="5623727c-0179-4903-bd23-b2b205689ab8">
      // <input type="hidden" name="draftId"            value="163874317"                     id="draftId"           />

      const draftId = document.querySelector('input[name="draftId"]').getAttribute('value')
      // const draftShareId = document.querySelector('meta[name="ajs-draft-share-id"]').getAttribute('content')

      process.stdout.write(JSON.stringify({draftId}))
      break;
    }

    case 'atl_token': {
      const atl_token_payload = get_atl_token(document)
      process.stdout.write(JSON.stringify(atl_token_payload))
      break;
    }
      
    case 'atl_token:pageId': {
      const atl_token_payload = get_atl_token(document)
      const pageId_payload = get_pageId(document)
      const pageTitle_payload = get_pageTitle(document)

      process.stdout.write(JSON.stringify({...atl_token_payload, ...pageId_payload, ...pageTitle_payload}))
      break;
    }
      
    default:
      process.stdout.write(document.querySelector('meta[id="atlassian-token"]').getAttribute('content'))
  }
}

main();

