#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// const readline = require("node:readline");

// async function main() {
//   const rl = readline.createInterface({
//     input: process.stdin,
//   });

//   for await (const line of rl) {
//     // process a line at a time
//     process.stdout.write(`line: ${line}\n`);
//   }
// }

// main();

let data = "";
const { JSDOM } = require('jsdom');

async function main() {
  for await (const chunk of process.stdin) data += chunk;

  const dom = new JSDOM(data.toString())

  // Get name of dependency from page
  const name = dom.window.document.querySelector("#__layout > div > div > div.package-container > div > div.package-header-container > header > div.intro > div.name > h1").textContent

  // Collect scores from page
  const scores = Array.from(dom.window.document.querySelectorAll('ul.scores li')).map(entry => {
    const name = entry.querySelector('span').textContent

    let status
    const classList = entry.querySelector('a div.vue--pill').classList
    if (classList.contains('vue--pill--success')) status = 'success'
    else if (classList.contains('vue--pill--warning')) status = 'warning'
    else if (classList.contains('vue--pill--danger')) status = 'danger'

    const value = entry.querySelector('a div.vue--pill span.vue--pill__body').textContent

    return {name, value, status}
  })

  // Get percentage from page
  let percentage = dom.window.document.querySelector("#__layout > div > div > div.package-container > div > div.package-header-container > div > div > div > div.vue--layout-space-between > div.number > div > span").textContent
  const [dividend, divisor] = percentage.split(/ *\/ */).map(entry => parseInt(entry))
  // const percentage2 = Math.ceil(dividend / divisor) * 10;

  percentage = dividend
  
  // Write dependency summary to snyk.txt
  console.log(JSON.stringify({name, percentage, scores}));
}

main();

/*

for dependency in base-64 compression connect-memcached cookie cookie-parser deepmerge express express-graphql express-list-routes express-session express-validator fs helmet is-port-reachable js-yaml jwt-decode langs lds-cf-service-config memcached memoizee merge morgan next node-fetch passport passport-custom postcss-modules postcss-nesting postcss-variables process react react-dom styled-components swagger-ui-express http-proxy jsdom nodemon; do

# for dependency in lds-cf-service-config fs; do

for dependency in appdynamics base-64 compression connect-memcached cookie cookie-parser deepmerge express express-graphql express-list-routes express-session express-validator fs graphql helmet http-proxy is-port-reachable js-yaml jwt-decode memcached memoizee merge morgan next node-fetch nodemon passport passport-custom postcss-modules postcss-nesting postcss-variables process react react-dom react-error-boundary styled-components swagger-ui-express; do



for dependency in $(cat package.json | jq -r '.dependencies * .devDependencies | keys | join("\n")' | xargs); do

echo "Processing $dependency..."
payload=$(curl "https://snyk.io/advisor/npm-package/${dependency}" 2> /dev/null | ~/scripts/snyk/snyk.js)

sleep 1

if [[ $? == 0 ]]; then
echo "$payload" | tee -a snyk.txt
else
echo "{\"name\":\"$dependency\",\"percent\":null,"scores":[]}" | tee -a snyk.txt
fi
done

cat snyk.txt | /Users/dcvezzani/scripts/snyk/snyk-format.js


cat snyk.txt | /Users/dcvezzani/scripts/snyk/snyk-format.js | jq '.' > snyk.json

~/scripts/snyk/snyk-format.js | jq '. | sort_by(.percentage)' > "$(basename $(pwd))-detailed-health-report.json"



npm ls --all
npm ls [dependency]
npm ls --depth=[depth]


npm ls loader-utils


# get deprecations
jq -r '.packages | to_entries[] | select(.value.deprecated != null) | "\(.key):\n\(.value.deprecated)\n"' package-lock.json


jq -r '.packages | to_entries[] | select(.value.deprecated != null) | .key' package-lock.json | perl -p -e 's/node_modules\///; s/(.*)/"$1"/; s/\n/ /'


# get dependency trees for deprecations
for dependency in $(jq -r '.packages | to_entries[] | select(.value.deprecated != null) | .key' package-lock.json | perl -p -e 's/node_modules\///; s/(.*)/"$1"/;' | xargs); do
echo Processing $dependency... 1>&2
content=$(cat << EOL
#### $dependency
\`\`\`
npm ls $dependency

$(npm ls $dependency)
\`\`\`
EOL
)
echo "$content\n"
done | pbcopy





for dependency in postcss-variables passport-custom connect-memcached appdynamics express-graphql memcached express-list-routes base-64; do


 */
