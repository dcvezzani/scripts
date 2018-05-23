#!/bin/bash
# ~/scripts/generateComponent.sh

if [[ "$1" == "" ]]; then
	echo Usage: /Users/dcvezzani/scripts/generateComponent.sh FindPersonListEntry
	exit
fi

name="$1"
label=$(echo "$name" | perl -0pe 's<(^[A-Z]|(?![a-z])[A-Z])>< "-" . lc $1 >ge' | perl -0pe 's/^-//')
generatePath=/Users/dcvezzani/projects/v1Directory/fe/src/components

sed "s#\$label#$label#g; s#\$name#$name#g; " ~/scripts/templates/template-component.vue > $generatePath/$name.vue

echo "
template: 
<$name></$name>

javascript:
import $name from '@/components/$name'

  components: { $name },
"
