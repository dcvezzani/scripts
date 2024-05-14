const chai = require('chai')
const { expect, assert } = chai
const helpers = require('./endpoints.helpers.js')

describe('{app} {tier} endpoints', function() {

  describe('/version', function() {
    helpers.createTest('get', `/version`, {label: null, update: false}, res => {
      expect(res.actualKeys).to.deep.equal(res.expectedKeys)
    })
  })

})

/*

for route in \
'/version' \
'/roles' \
'/fakeroles' \
'/si/api/article' \
'/si/api/config' \
'/si/api/content' \
'/si/api/custom-page' \
'/si/api/site-header' \
'/si/api/dictionary' \
'/si/api/permissions' \
'/si/api/ping' \
; do
cat << EOL
  describe('$route', function() {
    helpers.createTest('get', \`$route\`, {label: null, update: false}, res => {
      expect(res.actualKeys).to.deep.equal(res.expectedKeys)
    })
  })
EOL
echo
done | pbcopy

*/
