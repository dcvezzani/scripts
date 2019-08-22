#!/bin/bash

# /Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles'
# /Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles' items:array href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array
# /Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles' items,stuff/items-item:array href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array

# /Users/dcvezzani/scripts/pb-generate-transform.sh 'good-stuff' items:array:items/items-item href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array junk:string myUrl:url:some/good/xpath
# /Users/dcvezzani/scripts/pb-generate-transform.sh 'junky-fluff' href:url title:string description:string items:array:items/items-item pretitle:string mediaAspectRatio:string image:image items:close-array junk:string cards:array:cards/cards-item myUrl:url:some/good/xpath blah:string:bleh lunch:image cards:close-array

transformName="$1"

projectPath="/Users/dcvezzani/projects/church-history-adviser-pubhub"
transformPath="${projectPath}/src/main/xquery//sites/church-history-adviser/transforms/church-history-adviser"
templatePath="/Users/dcvezzani/scripts/templates"

if [ "$transformName" == "" ]; then
  echo "Usage: ./pb-generate-transform.sh 'vertical-tiles' items:array:items/items-item href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array"
  exit 1
fi

transformName="$1-transform"


newTransform=$(cat "${templatePath}/publisher-transform-template.xml" | perl -p -e 's/__TRANSFORM_NAME__/'"$transformName"'/g; ')

shift

read -r -d '' stringSnippet <<-'EOF'
"__COMPONENT_NAME__": th:string-value(\$item/__COMPONENT_PATH__), 
EOF

read -r -d '' urlSnippet <<-'EOF'
"__COMPONENT_NAME__": th:url-value(\$item/__COMPONENT_PATH__, \$g:site-host, \$g:lang), 
EOF

read -r -d '' imageSnippet <<-'EOF'
"__COMPONENT_NAME__": object-node {
    "src": th:image-url(\$item/__COMPONENT_PATH__/src),
    "alt": th:string-value(\$item/__COMPONENT_PATH__/alt)
},
EOF

read -r -d '' arraySnippet <<-'EOF'
        "__COMPONENT_NAME__": array-node {
            for \$item in \$element/__COMPONENT_PATH__
            return object-node {
                __COMPONENT_ATTRS__
            }
        },
EOF

read -r -d '' importNamespaceG <<-'EOF'
import module namespace g = "http://lds.org/code/church-history-adviser/globalVariables" at "/sites/church-history-adviser/modules/globalVariables.xqy";
EOF


indentation=$(echo "$newTransform" | sed '/__COMPONENT_ATTRS__/!d; ' | perl -0pe 's#^([ _]+)__COMPONENT_ATTRS__.*$#$1#ms; ')

for term in "$@"
do

  # first: %:*
  # last: ##*:
  # items,items/items-item:array
  group="${term%:*}"
  test=$(echo "$group" | grep ',')

  if [ "$?" == "0" ]; then
    componentName="${group%,*}"
    componentType="${term##*:}"
    componentPath="${group##*,}"
    componentPath=$(echo "$componentPath" | perl -0pe 's#\/#\\\\\\\/#g')
  else
    componentName="${term%:*}"
    componentType="${term##*:}"

    if [ "$componentType" == "array" ]; then
      componentPath=$(echo "$componentName/${componentName}-item" | perl -0pe 's#\/#\\\\\\\/#g')
    else
      componentPath=$(echo "$componentName" | perl -0pe 's#\/#\\\\\\\/#g')
    fi
  fi


  # echo ">>> componentType: ${componentType}, '$componentPath'"
  case $componentType in
      array)
        # echo "componentPath: '${componentPath}'"
        snippet=$(echo "$arraySnippet" | perl -0pe 's/"__COMPONENT_NAME__/        "'"$componentName"'/g; s/__COMPONENT_PATH__/'"$componentPath"'/g; s/^ */'"$indentation"'/; s/^ {8}// ')
        newTransform=$(echo "$newTransform" | perl -0pe 's#^(.*__COMPONENT_ATTRS__.*)$#'"${indentation}${snippet}"'\n$1#m')
        indentation=$(echo "$newTransform" | sed '/__COMPONENT_ATTRS__/!d; ' | perl -0pe 's#^([ _]+)__COMPONENT_ATTRS__.*$#$1#ms; ')
        # echo ">> '${indentation}'"
        ;;
      close-array)
        newTransform=$(echo "$newTransform" | perl -0pe 's#,(.*\n).*\n.*__COMPONENT_ATTRS__.*\n#\1#m')
        indentation=$(echo "$newTransform" | sed '/__COMPONENT_ATTRS__/!d; ' | perl -0pe 's#^([ _]+)__COMPONENT_ATTRS__.*$#$1#ms; ')
        ;;
      string|text)
        snippet=$(echo "$stringSnippet" | perl -0pe 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_PATH__/'"$componentPath"'/g; ')
        newTransform=$(echo "$newTransform" | perl -0pe 's#(.*__COMPONENT_ATTRS__.*)#'"${indentation}${snippet}"'\n$1#m')
        ;;
      image)
        snippet=$(echo "$imageSnippet" | perl -0pe 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_PATH__/'"$componentPath"'/g; s/\n/\n'"$indentation"'/gm; ')
        newTransform=$(echo "$newTransform" | perl -0pe 's#(.*__COMPONENT_ATTRS__.*)#'"${indentation}${snippet}"'$1#m')
        ;;
      url)
        snippet=$(echo "$urlSnippet" | perl -0pe 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_PATH__/'"$componentPath"'/g; ')
        newTransform=$(echo "$newTransform" | perl -0pe 's#(.*__COMPONENT_ATTRS__.*)#'"${indentation}${snippet}"'\n$1#m')

        test=$(echo "$newTransform" | grep 'import module namespace g =')
        if [ ! "$?" == "0" ]; then
          newTransform=$(echo "$newTransform" | perl -0pe 's#(\nimport module namespace.*)#\n'"${importNamespaceG}"'$1#m')
        fi
        ;;
      *)
        # unknown option
        ;;
  esac

# echo "name: $componentName, type: $componentType, path: $componentPath"
done

echo "$newTransform" | perl -0pe 's#,([^,]*\n).*__COMPONENT_ATTRS__.*\n#\1#gm' | tee "${transformPath}/${transformName}.xqy"

