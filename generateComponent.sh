#!/bin/bash
# ~/scripts/generateComponent.sh

if [[ "$1" == "" ]]; then
	echo Usage: /Users/dcvezzani/scripts/generateComponent.sh ParentEntry ChildEntry
	exit
fi

parentComp="$1"
name="$2"
applyTemplate="$3"
label=$(echo "$name" | perl -0pe 's<(^[A-Z]|(?![a-z])[A-Z])>< "-" . lc $1 >ge' | perl -0pe 's/^-//')
# generatePath=/Users/dcvezzani/projects/v1Directory/fe/src/components
generatePath=/Users/dcvezzani/projects/stockman/src/components


sed "s#\$label#$label#g; s#\$name#$name#g; " ~/scripts/templates/template-component.vue > $generatePath/$name.vue

# if [[ "$parentComp" == "" ]]; then
# echo "
# template: 
# <$name></$name>

# javascript:
# import $name from '@/components/$name'

#   components: { $name },
# "
# else
	content=$(perl -0pe 's#<script>#<script>\nimport '"$name"' from '"'"'@/components/'"$name"''"'"';#gm' "$generatePath/$parentComp.vue")

	silenceOutput=$(grep '  components: {' "$generatePath/$parentComp.vue");

	if [[ "$?" != "0" ]]; then
		content=$(echo "$content" | perl -0pe 's#export default \{#export default \{\n  components: \{\},#gm')
	fi

	content=$(echo "$content" | perl -0pe 's#components: \{#components: \{ '"$name"',#gm')

	if [[ "$applyTemplate" == "applyTemplate:true" ]]; then
		echo "$content" | perl -0pe 's#(^<template>\n.*\n)#$1<'"$name"'><\/'"$name"'>\n#gm' > "$generatePath/$parentComp.vue"
	else
		echo "$content" > "$generatePath/$parentComp.vue"
	fi
# fi


# for childComp in PhotoDetail DetailTitle DetailDescription DetailKeywords DetailCategories DetailAdditionalInfo DetailAttachRelease DetailAgencyStatus; do
# 	~/scripts/generateComponent.sh PhotoDetails "$childComp"
# done

