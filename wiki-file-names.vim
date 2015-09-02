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

  let $WFN = strftime("(%a, %d %b %Y)")."* [".@w." (".strftime("%Y-%m-%d").")](".@y.")"
  echo $WFN
endfunction
:command! -range WFN :call WikiFileName() | :r!echo "$WFN" | pbcopy


