const fs = require('fs')
const fetch = require('./node-fetch')
const { config } = require('./config')
const chai = require('chai')
const { expect, assert } = chai

const UPDATE_ALL_EXPECTED = false
const VERBOSE = true
const LOG_INDENTATION = `      `

const helpers = require('./helpers.js')({UPDATE_ALL_EXPECTED, VERBOSE, LOG_INDENTATION})

async function makeRequest(path, options={}, recordAndGather) {
  const {contentType, extension, method, body, label} = options

  const url = `${config.FE_BASE_URL}${path}`
  const fetchArgs = [
    url,
    {
        method,
        headers: {
            // 'Content-Type': 'application/json',
            // 'Authorization': `Basic ${config.authorization.basic}`,
            // Cookie,
        },
    }
  ]

  if (contentType) fetchArgs[1].headers['Content-Type'] = contentType

  if (['DELETE', 'POST'].includes(method)) {
    fetchArgs[1].headers = {
      ...fetchArgs[1].headers,
      "mode": "cors",
      "credentials": "include"
    }
  }

  if (!!body) fetchArgs[1].body = JSON.stringify(body)

  const filename = helpers.getFilename({path, fetchArgs, extension, label})
  
  // helpers.log(`🚀 Requesting endpoint: ${JSON.stringify(fetchArgs, null, 2)}`)
  helpers.log(`🚀 Requesting endpoint: ${url}${label ? ' ('+label+')' : ''}`)
  const response = await fetch(...fetchArgs)

  if (!response.ok) return Promise.reject(new Error(`Expected 200 http response status; got ${response.status}`))

  if (!recordAndGather) throw new Error(`recordAndGather() callback not defined by method delegating to makeRequest()`)

  const {payload, actualKeys, expectedKeys} = recordAndGather(response, {filename, ...options})

  return {response, filename, payload, actualKeys, expectedKeys}
}

async function makeHtmlRequest(path, options={}) {
  const extension = 'html'
  const contentType = 'text/html'

  return makeRequest(path, {...options, extension, contentType}, async (response, options) => {
    helpers.recordAndGatherText(await response.text(), options)
  })
}

async function makeJsonRequest(path, options={}) {
  const extension = 'json'
  const contentType = 'application/json'

  return makeRequest(path, {...options, extension, contentType}, async (response, options) => {
    const emptyContent = response?.headers['content-length'] === 0
    const responsePayload = emptyContent ? null : await response.json()
    helpers.recordAndGatherJson(responsePayload, options)
  })
}

async function makeJsRequest(path, options={}) {
  const extension = 'js'
  const contentType = 'application/javascript'

  return makeRequest(path, {...options, extension, contentType}, async (response, options) => {
    helpers.recordAndGatherText(await response.text(), options)
  })
}

function createTest(method, path, options, cb=null) {
  const { enableTestCase=true, runDefaultTests=true, responseType='json', label } = options

  let makeRequest = makeHtmlRequest
  switch(responseType) {
    case 'json': {
      makeRequest = makeJsonRequest
      break
    }
    case 'js': {
      makeRequest = makeJsRequest
    }
  }

  const methodUpperCase = method.toUpperCase()
  const testName = (!!label) ? `${methodUpperCase} ${path} - ${label}` : `${methodUpperCase} ${path}`

  if (enableTestCase) {
    it(testName, async function() {
      const res = await makeRequest(path, {...options, method: methodUpperCase})
      if (cb) cb(res)
      if (runDefaultTests) {
        expect(res.actualKeys).to.deep.equal(res.expectedKeys)
      }
    })
  } else {
    xit(testName, async function() {})
  }
}

module.exports = {
  ...helpers,
  makeJsonRequest,
  makeHtmlRequest,
  makeJsRequest,
  createTest,
}
