#!/bin/bash

# /Users/dcvezzani/scripts/pb-generate-form.sh 'mlp-hero-search' 'MLP Hero Search' 'title,Title:text' 'image,Image:image'

# /Users/dcvezzani/scripts/pb-generate-form.sh \
# mlp-spot-link 'MLP Spot Link' 'title,Title:text:*' 'description,Description:text' 'link,Link:text'
# 
# /Users/dcvezzani/scripts/pb-generate-form.sh \
# mlp-spot-link-block 'MLP Spot Link Block' 'spotLinks,Spot Links:dlist' 'title,Title:text:*' 'description,Description:text' 'link,Link:text'
# 
# /Users/dcvezzani/scripts/pb-generate-form.sh \
# vertical-tiles 'Veritical Tiles' 'items,Vertical Tile Items:dlist' title,Title:text:* pretitle,Pre-Title:text description,Description:text href,Href:text:* image,Image:image 'mediaAspectRatio,Media Aspect Ratio:text'
# 
# /Users/dcvezzani/scripts/pb-generate-form.sh \
# horizontal-tiles 'Horizontal Tiles' 'items,Horizontal Tile Items:dlist' title,Title:text:* pretitle,Pre-Title:text description,Description:text href:Href:text:* image,Image:image
# 
# /Users/dcvezzani/scripts/pb-generate-form.sh \
# drawer 'Drawer' 'drawerLabel,Drawer Label:text:*' 'components,Components:dlist' 'componentName,Component Name:text:*' 'contactCards,Contact Cards:dlist' name,Name:text:* title,Title:text phone,Phone:text email,Email:text


formName="$1"
formLabel="$2"

# projectPath="/Users/dcvezzani/projects/church-history-adviser-pubhub"
projectPath="/Users/dcvezzani/projects/fh-pubhub"
formPath="${projectPath}/src/main/xquery/_configuration/ALL/ice/ice-forms"
templatePath="/Users/dcvezzani/scripts/templates"

if [ "$formName" == "" ]; then
  echo "Usage: ./pb-generate-form.sh 'mlp-hero-search' 'MLP Hero Search' 'text:title:Title' 'image:image:Image'"
  exit 1
fi

if [ "$formLabel" == "" ]; then
  echo "Usage: ./pb-generate-form.sh 'mlp-hero-search' 'MLP Hero Search' 'text:title:Title' 'image:image:Image'"
  exit 1
fi

newForm=$(cat "${templatePath}/publisher-form-template.xml" | perl -p -e 's/__FORM_NAME__/'"$formName"'/g; s/__FORM_LABEL__/'"$formLabel"'/g; ')

shift
shift

indentation=$(echo "$newForm" | sed '/__COMPONENT_SECTION__/!d; ' | perl -0pe 's#^([ ]+).*$#$1#ms; ')
# echo ">>> indentation: '${indentation}'"

for term in "$@"
do

  chk=$(echo "$term" | grep ':\*')
  if [ "$?" == "0" ]; then
    required="true"
    term=$(echo "$term" | perl -0pe 's#:\*##g')
  else
    required="false"
  fi

  # term='image:my-image:My Image'
  # first: %:*
  # last: ##*:
  componentType="${term##*:}"
  group="${term%:*}"
  componentName="${group%,*}"
  componentLabel="${group##*,}"

  # echo "componentType: ${componentType}, group: ${group}, componentName: ${componentName}, componentLabel: ${componentLabel}"
    
  case $componentType in
      dlist)
        templateContent=$(cat "${templatePath}/publisher-dynamic-component.xml")
        componentDlist=$(echo "${templateContent}__END__" | perl -p -e 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_LABEL__/'"$componentLabel"'/g; s/\n/\n'"$indentation"'/gm; s/__END__.*//gms; ')
        # if [ "$required" == "false" ]; then componentText=$(echo "$componentText" | perl -p -e 's/required//g'); fi
        newForm=$(echo "$newForm" | perl -0pe 's#^(.*__COMPONENT_SECTION__.*)$#'"${indentation}${componentDlist}"'#gm; ')
        indentation=$(echo "$componentDlist" | sed '/__COMPONENT_SECTION__/!d; ' | perl -0pe 's#^([ ]+).*$#$1#ms; ')
        ;;
      close-dlist)
        newForm=$(echo "$newForm" | perl -0pe 's#^(.*__COMPONENT_SECTION__.*)\n##m')
        ;;
      text|string)
        componentText=$(cat "${templatePath}/publisher-component-template-text.xml" | perl -0pe 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_LABEL__/'"$componentLabel"'/g; s/\n/\n'"$indentation"'/gm; s/ *$//gs; ')
        if [ "$required" == "false" ]; then componentText=$(echo "$componentText" | perl -0pe 's/required//g'); fi
        newForm=$(echo "$newForm" | perl -0pe 's#^(.*__COMPONENT_SECTION__.*)$#'"${indentation}${componentText}"'$1#gm; ')
        ;;
      image)
        templateContent=$(cat "${templatePath}/publisher-component-template-image.xml")
        componentImage=$(echo "${templateContent}__END__" | perl -0pe 's/__COMPONENT_NAME__/'"$componentName"'/g; s/__COMPONENT_LABEL__/'"$componentLabel"'/g; s/required//g; s/\n/\n'"$indentation"'/gm; s/__END__.*//gms; ')
        # echo ">>> componentImage: '${componentImage}'"
        # if [ "$required" == "false" ]; then componentImage=$(echo "$componentImage" | perl -p -e 's/required//g'); fi
        newForm=$(echo "$newForm" | perl -0pe 's#^(.*__COMPONENT_SECTION__.*)$#'"${indentation}${componentImage}"'$1#gm; ')
        ;;
      *)
            # unknown option
      ;;
  esac
done

echo "$newForm" | perl -0pe 's#^(.*__COMPONENT_SECTION__.*)\n##gm' | tee "${formPath}/${formName}.xml"
