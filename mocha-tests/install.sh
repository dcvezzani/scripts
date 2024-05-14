#!/bin/bash

tar xvf ~/scripts/mocha-tests/mocha-tests.tar
mkdir -p test/data

npm i chai html mocha nodemon cross-env node-fetch --save-dev
npm i app-root-path express-list-routes morgan --save
echo

cat << EOL
add npm scripts

  "scripts": {
    "test:base": "cross-env NODE_ENV=unit_test NODE_TLS_REJECT_UNAUTHORIZED=0 ./node_modules/.bin/mocha --timeout 15000",
    "test:pre": "npm run test:base ./test/pre.test.js",
    "test": "cross-env NODE_ENV=unit_test NODE_TLS_REJECT_UNAUTHORIZED=0 ./scripts/test.sh",
    "test:tdd": "nodemon --ignore ./test/data --exec \"cross-env NODE_TLS_REJECT_UNAUTHORIZED=0 npm run test\""
  },
EOL
echo

cat << EOL
update server.js (if this is a node express application)

const logger = require('morgan');
...

server.use(logger((dev) ? 'dev' : 'combined'));
...

if (config?.verbosity?.startup?.routes && (dev || test)) {
        const expressListRoutes = require("express-list-routes");
        expressListRoutes(server, { prefix: "" });
}
EOL
echo

cat << EOL
update routes to include /version (if this is a node express application)

  router.get('/version', (req, res, next) => {
    const version = process.env.npm_package_version;
    const name = process.env.npm_package_name;

    if(!version || !name){
        const packageJsonPath = require('app-root-path').resolve('/package.json');
        const packageJson = packageJsonPath ? require(packageJsonPath) : {};
        version = packageJson.version || '';
        name = packageJson.name || '';
    }

    res.setHeader('Cache-Control', 'no-store');
    res.json({
        service: name,
        version: version
    })
  })
EOL
echo

cat << EOL
update .gitignore

./test/data
EOL
echo
