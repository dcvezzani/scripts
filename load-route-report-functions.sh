func createRouteReport() {
local filename="$1"
local _dirname=$(dirname $filename)
local routeGroup=${$(basename $1)%%.*}

if [[ -z $routeGroup ]]; then
cat << EOL
Usage: createRouteReport <filename>
E.g.,: createRouteReport /Users/dcvezzani/projects/recovery-fe/server/routes/secure.js
EOL
fi

# def isEnsureSignedIn($f): ...;
local isTokenExists='def isTokenExists($token): ((map(select(.type == "Identifier" and .name == $token)) | length) > 0)'
# local isEnsureSignedIn='def isEnsureSignedIn: ((map(select(.type == "Identifier" and .name == "ensureSignedIn")) | length) > 0)'
# local isEnsureSignedInSecurePath='def isEnsureSignedInSecurePath: ((map(select(.type == "Identifier" and .name == "ensureSignedInSecurePath")) | length) > 0)'

local commonProperties=$(cat << 'EOL'
method: $expression.callee.property.name, ensureSignedIn: $ensureSignedIn, ensureSignedInSecurePath: $ensureSignedInSecurePath, start: $expression.loc.start.line, end: $expression.loc.end.line
EOL
)

CMD=$(cat << EOL
cat "$filename" | /Users/dcvezzani/scripts/parse-code-to-json.js | jq '${isTokenExists}; .body | map(select(.type == "ExpressionStatement")) | arrays | 
map(. | objects | .expression as \$expression | \$expression | 

(if ((.arguments | length) == 0) then ({type}) else (
  .arguments as \$arguments | 
  \$arguments | isTokenExists("ensureSignedIn") as \$ensureSignedIn |
  \$arguments | isTokenExists("ensureSignedInSecurePath") as \$ensureSignedInSecurePath |
  \$arguments |
    if (.[0].type == "Literal") 
      then (.[0] | {type, path: .value, ${commonProperties}}) 
    elif (.[0].type == "TemplateLiteral") 
      then (.[0] as \$firstArgument | \$firstArgument | .quasis[0].value | {type: \$firstArgument.type, path: .cooked, ${commonProperties}}) 
    elif (.[0].type == "ArrayExpression") 
      then (.[0] as \$firstArgument | \$firstArgument | .elements | map(.value) | join(" or ") | {type: \$firstArgument.type, path: ., ${commonProperties}}) 
    else ({type}) end
) end)

)' > "${_dirname}/code-blocks-${routeGroup}.txt"
echo "File written to '${_dirname}/code-blocks-${routeGroup}.txt"
EOL
)
eval "$CMD"
}

# createRouteReport /Users/dcvezzani/projects/recovery-fe/server/routes/secure.js
# createRouteReport /Users/dcvezzani/projects/recovery-fe/server/routes/insecure.js
# createRouteReport /Users/dcvezzani/projects/recovery-fe/server/routes/postProcess.js
# createRouteReport /Users/dcvezzani/projects/temples-fe/server/routes/secure.js

