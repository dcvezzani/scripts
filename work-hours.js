#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

/*
function capitalize(line) {
    // return line.toUpperCase();
    return `${line.slice(0,1).toUpperCase()}${line.slice(1)}`
}

input.on('data', line => {
    output.write(capitalize(line));
    output.write('\n');
});
*/

let summary = {}
// let groupSummary = {}
const reduce = (line) => {
    const md = line.match(/^([^;]+);([^;]+);(.+)$/)
    if (md) {
      if (process.argv.length > 2 && process.argv[2] === 'group'){
        const groupKey = `${md[2]}`.replace(/-.*$/, '')
        if (!summary.hasOwnProperty(groupKey)) summary[groupKey] = 0.0
        summary[groupKey] += parseFloat(md[1])
      } else {
        const key = `${md[2]};${md[3]}`
        if (!summary.hasOwnProperty(key)) summary[key] = 0.0
        summary[key] += parseFloat(md[1])
      }
    }
}

input.on('data', line => {
    reduce(line)
});

const compareFunc = (a, b, dir="asc") => {
  if (dir === "desc") {
    return a < b ? 1 : a > b ? -1 : 0
  } else {
    return a > b ? 1 : a < b ? -1 : 0
  }
}

const createSummary = (source) => {
  return (response, key) => {
    const hours = Number.parseFloat(source[key])
    response.entries.push({hours, description: key})
    response.total += hours
    return response
  }
};

const sortLines = (a, b)=>{
  aParts = a.split(/;/)
  bParts = b.split(/;/)

  const hoursCmp = compareFunc(aParts[0], bParts[0], "desc")
  let cmp = hoursCmp

  if (cmp === 0) {
    const topicCmp = compareFunc(aParts[1], bParts[1], "asc")
    cmp = topicCmp
  }

  if (cmp === 0) {
    const descriptionCmp = compareFunc(aParts[2], bParts[2], "asc")
    cmp = descriptionCmp
  }

  return cmp
}

input.on('end', () => {
  const response = Object.keys(summary).reduce(createSummary(summary), {entries: [], total: 0.0})
  // const response_groupSummary = Object.keys(groupSummary).reduce(createSummary(groupSummary), {entries: [], total: 0.0})
  
  const lines = response.entries.map(entry => `${parseFloat(entry.hours).toFixed(1)}; ${parseFloat(entry.hours/response.total).toFixed(2)};${entry.description}`)
  // const lines_groupSummary = response_groupSummary.entries.map(entry => `${parseFloat(entry.hours).toFixed(1)}; ${parseFloat(entry.hours/response.total).toFixed(2)};${entry.description}`)

  console.log(lines.sort(sortLines).join("\n"))
  // console.log()
  // console.log(lines_groupSummary.sort(sortLines).join("\n"))
});

input.on('error', e => {
  console.error(e)
});


/*

data=$(cat << EOL
0.5; SI-195; testing
0.5; SI-195; testing
0.5; ADMIN; standup
0.5; MISRF; feedback form, simplified requirements
0.5; SI-195; testing
0.5; ARPWEB; arp release
0.5; CSTEMPLE; prod issue troubleshooting and resolution
1.0; CSTEMPLE; prod issue troubleshooting and resolution
0.5; CSTEMPLE; prod issue troubleshooting and resolution
0.5; CSTEMPLE; weekly meeting
1.0; CSTEMPLE; prod issue troubleshooting and resolution
1.0; CSTEMPLE; prod issue troubleshooting and resolution
EOL
)
echo "$data" | NODE_PATH=$(npm root --quiet --location=global) /Users/dcvezzani/scripts/work-hours.js

 * */
