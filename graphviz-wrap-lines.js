const wrapText = require("wrap-text");

const prefix=process.env.PREFIX || ''
const suffix=process.env.SUFFIX || ''

const lines = wrapText(process.argv[2], process.argv[3] || 40).split(/\n/)
const output = lines.map((line, index) => {
  if (index === 0) return line
  return `${prefix}${line}${suffix}`
}).join("\n")

console.log(output)

