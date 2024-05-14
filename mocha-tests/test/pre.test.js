const fs = require('fs')
const fetch = require('./node-fetch')
const chai = require('chai')
const { expect, assert } = chai
const { config } = require('./config')

const MONITOR = config.monitor === true;

if (! fs.existsSync(`./test/data`)) {
  // fs.mkdirSync(`./test/data`, {recursive: true})
  fs.mkdirSync(`./test/data`)
}

it('pre-test; wait for server restart', function() {
  setTimeout(() => {
    return Promise.resolve()
  }, 2000)

  // const fetchArgs = [
  //   `${config.FE_BASE_URL}/version`,
  //   {
  //       method: 'GET',
  //       headers: {
  //           'Content-Type': 'application/json',
  //       },
  //   }
  // ]

  // return new Promise(resolve => {
  //   let poller = async () => {
  //     const response = await fetch(...fetchArgs)
  //     if (response.ok) {
  //       console.log(await response.json())
  //       clearInterval(poller)
  //       resolve()
  //     }
  //   }
  //   poller = setInterval(poller, 2000)
  // })
})
