### ================
schemaExample() {
cat << EOL
                  "$1": {
                    "value": {
                      "permissions": [
                        "edup.perm.Administrator",
                        "edup.perm.CalledPersonnel",
                        "edup.perm.EmployeeTeachers",
                        "edup.perm.Parent",
                        "edup.perm.PriesthoodLeader",
                        "edup.perm.Public",
                        "edup.perm.Student"
                      ]
                    }
                  }
EOL
}

### ================
schemaDefinition() {
cat << EOL
      "$1": {
        "type": "object",
        "properties": {
          "permissions": {
            "type": "string",
            "example": "edup.perm.Public"
          }
        }
      }
EOL
}

### ================
schemaString() {
example="$1 example"
if [[ $2 != '' ]]; then
example="$2"
fi

cat << EOL
          "$1": {
            "type": "string",
            "example": "$example"
          }
EOL
}

### ================
schemaArray() {
cat << EOL
              "$1": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "example": [
                  "edup.perm.Administrator",
                  "edup.perm.CalledPersonnel",
                  "edup.perm.EmployeeTeachers"
                ]
              }
EOL
}

### ================
schemaCurlyBraces() {
local children=$(cat < /dev/stdin)

cat << EOL
    {
$children
    }
EOL
}

### ================
addComma() {
local children=$(cat < /dev/stdin)

cat << EOL
${children},
EOL
}

### ================
schemaObject() {
local children=$(cat < /dev/stdin)
# local children=$(
# while read -t 1 line; do
#     echo "$line"
# done
# )

cat << EOL
      "$1": {
        "type": "object",
        "properties": {
$children
        }
      }
EOL
}

### ================
schemaLeafObject() {
cat << EOL
      "$1": {
        "type": "object",
        "properties": {
        }
      }
EOL
}

### ================
responseSchemaRef() {
cat << EOL
                  "\$ref": "#/components/schemas/$1Response"
EOL
}


response=$(cat << EOL
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "schema": {
$(responseSchemaRef 'empty')
                },
                "examples": {
$(schemaExample 'example-01'),
$(schemaExample 'example-02')
                }
              }
            }
          }
        }
EOL
)

### ================
parameterRef() {
cat << EOL
          { "\$ref": "#/components/parameters/$1" }
EOL
}

### ================
parameter() {
required="$4"
if [[ $required == "" ]]; then
  required="false"
fi

cat << EOL
      "$1": {
        "name": "$1",
        "in": "$2",
        "description": "Description for $1",
        "required": $required,
        "schema": {
          "type": "$3"
        }
      }
EOL
}

### ================
queryParameter() {
parameter $1 query string $2
}

### ================
headerParameter() {
parameter $1 header string $2
}

### ================
pathParameter() {
parameter $1 path string $2
}


### ================
requestBodyBlock() {
required="$2"
if [[ $required == '' ]]; then
required='false'
fi
cat << EOL
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "\$ref": "#/components/schemas/$1"
              }
            }
          },
          "required": $required
        }
EOL
}

### ================
routeMethodBlock() {
method="$2"
if [[ $method == '' ]]; then
method='get'
fi

hasBody=$(echo "$method" | grep -E 'post|put|patch' >/dev/null 2>&1 ; if [[ $? == 0 ]]; then echo "true"; else echo "false"; fi)

tags='["Default"]'
if [[ ! -z $TAGS ]]; then
tags="$TAGS"
fi

cat << EOL
      "$method": {
        "tags": $tags,
        "description": "Description of /$1",
        "parameters": [
$(parameterRef 'lang'),
$(parameterRef 'context'),
$(parameterRef 'uri')
        ],
$(if [[ $hasBody == 'true' ]]; then requestBodyBlock $1 true | addComma; fi)
$response        
      }
EOL
}

### ================
routePath() {
pathName="$1"
shift

cat << EOL
    "/$pathName": {
$(
while [[ $1 != '' ]]; do
routeMethodBlock $pathName $1
shift
done
)    
    }
EOL
}

### ================
usageExamples() {

cat << 'EOL'
### Examples

Create parameter definitions:

(cat << EOL2
$(headerParameter 'authorization'),
$(queryParameter 'lang' true),
$(queryParameter 'context'),
$(pathParameter 'uri')
EOL2
) | schemaCurlyBraces

Create a schema definition (1)

(cat << EOL2
$(schemaString 'one'),
$(schemaArray 'fruit'),
$(schemaString 'two')
EOL2
) | schemaObject | schemaObject | schemaCurlyBraces | jq '.'

Create a schema definition (2)

(cat << EOL2
$(schemaString 'three'),
$(schemaArray 'cars'),
$(schemaString 'five'),
$(schemaLeafObject 'child3'),
$(schemaString 'six'),
$(schemaArray 'fruit'),
$(schemaLeafObject 'child2')
EOL2
) | schemaObject 'child1' | schemaObject 'top' | schemaCurlyBraces | jq '.'

Create a collection of route paths

(cat << EOL2
$(routePath 'one' get post),
$(routePath 'two'),
$(routePath 'three')
EOL2
) | schemaCurlyBraces | pbcopy
| jq '.'

EOL
}


cat << 'EOL'
Loaded swagger authoring functions

### Functions

schemaExample()
schemaDefinition()
schemaString()
schemaArray()
schemaCurlyBraces()
schemaObject()
schemaLeafObject()
responseSchemaRef()
parameterRef()
parameter()
queryParameter()
headerParameter()
pathParameter()
routePath()

### Show usage examples

usageExamples()

EOL
