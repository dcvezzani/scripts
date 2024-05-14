#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

async function main() {
  let data = "";
  for await (const chunk of process.stdin) data += chunk;

  const knexSql = JSON.parse(data)
  const questionMark = /\?/
  const sql = knexSql.bindings.reduce((sql, binding) => {
    let bindingToken = binding
    if (typeof binding === 'string') bindingToken = `'${binding}'`

    return sql.replace(questionMark, bindingToken)
  }, knexSql.sql)

  console.log(sql)
}

main();

