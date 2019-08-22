#!/bin/bash

filename="/Users/dcvezzani/Dropbox/journal/current/20181121-fixing-bug-where-multiple-site-context.md"
filename="$1"

if [ "$filename" == "" ]; then
  echo "Usage: ./md-to-confluence.sh /Users/dcvezzani/Dropbox/journal/current/20181121-fixing-bug-where-multiple-site-context.md"
  return
fi

countDown() {
grep -e '^```' "$filename" | wc -l | xargs
}

# cnt=$(grep -e '^```' "$filename" | wc -l | xargs)
cnt=$(grep -e '^```' "$filename" | wc -l | xargs)
while [[ $cnt > 0 ]]; do
  echo "$((cnt / 2)) block(s) to process"
  content=$(perl -p0e 's/^.*```([^`]*)```.*$/$1/sm' "$filename")
  # escapedContent=$(echo "$content" | perl -p0e 's/&/&amp\;/g; s/</&lt\;/g; s/>/&gt\;/g; s/([\(\)])/\\\1\;/g; s/([\;\"&])/\\\1/g; ')
  contentLinesLength=$(echo "$content" | wc -l)
  contentLinesLength=$((contentLinesLength * 2 - 2))
  echo "$contentLinesLength"
  # | sed "$((contentLinesLength - 1)),\$d"
  formattedLines=$(echo "$content" | perl -p0e 's#\n#\"\n<br>\n\"#g; ' | sed '1,2d; /^\"{1,2}$/d' | sed "$((contentLinesLength - 1)),\$d")
  echo "$formattedLines"

  # basic: e2NvZGV9
  # html, xml: e2NvZGU6bGFuZ3VhZ2U9eG1sfQ
  TABLE_BEGIN='<table class="wysiwyg-macro" style="background-image: url(/confluence/plugins/servlet/confluence/placeholder/macro-heading?definition=e2NvZGV9&amp;locale=en_GB&amp;version=2); background-repeat: no-repeat;" data-macro-name="code" data-macro-id="71dd1795-98ab-4914-a4a5-5e03bd1dedfb" data-macro-parameters="language=xml" data-macro-schema-version="1" data-macro-body-type="PLAIN_TEXT" data-mce-style="background-image: url(https://code.ldschurch.org/confluence/plugins/servlet/confluence/placeholder/macro-heading?definition=e2NvZGU6bGFuZ3VhZ2U9eG1sfQ&amp;locale=en_GB&amp;version=2); background-repeat: no-repeat;"><tbody><tr><td class="wysiwyg-macro-body"><pre>'
  TABLE_END='</pre></td></tr></tbody></table>'

  asdf=$(perl -i -p0e 's#^(.*)```([^`]*)```(.*)$#$1'"${TABLE_BEGIN}${formattedLines}\n${TABLE_END}"'$3#sm' "$filename")
  # cnt=$(grep -e '^```' "$filename" | wc -l | xargs)
  cnt=$(grep -e '^```' "$filename" | wc -l | xargs)
done

