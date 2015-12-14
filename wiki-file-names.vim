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

  let $WFN = strftime("(%a, %d %b %Y)")."* [".@w."](".@y.")"

  " include content and link to github wiki page
  " use `gx` when cursor on url to open in browser
  let cleanWfn = split($WFN, '') + ['https://github.com/crystalcommerce/core/wiki/dave-v-authored-documents' ]
  call append(".", cleanWfn)
  call cursor(line('.') + len(cleanWfn), 0)

  echo $WFN
endfunction
:command! -range WFN :call WikiFileName() | :r!echo "$WFN" | pbcopy

