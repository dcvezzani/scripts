function! WikiFileName(...)
  let @z = '`<i `</[a-zA-Z0-9]v$h"yy'
  normal @z

  "let @z = 'gv"wy'
  "normal @z

  let @z = 'o"ypV:s/\<./\u&/g`<v$h"wygv:s/[^a-zA-Z0-9]\+/-/g'
  normal @z

  "* [an api error for reports that have never worked?](Api-Error-for-Reports-That-Have-Never-Worked)

  let @z = '`<v$h"yyddk'
  normal @z

  let @z = '^hx'
  normal @z

  let $WFN = strftime("(%a, %d %b %Y)")."* [".@w."](".@y.")"

  " include content and link to github wiki page
  " use `gx` when cursor on url to open in browser
  let cleanWfn = split($WFN, '') + ['https://bitbucket.org/greenseedtech/storm/wiki/'.@y, 'https://bitbucket.org/greenseedtech/storm/wiki/edit/zonners-authored-documents', 'echo "Recent discovery', 'https://bitbucket.org/greenseedtech/storm/wiki/'.@y, '" | slackcat --channel storm-x --stream']

  call append(".", cleanWfn)
  " minus 4 for the slackcat lines; focus on http of wiki link
  call cursor(line('.') + (len(cleanWfn) - 3), 0)

  echo $WFN
endfunction
:command! -range WFN :call WikiFileName() | :r!echo "$WFN" | pbcopy

