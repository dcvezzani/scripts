function! JournalFileName(...)
  let @z = '`<i `</[a-zA-Z0-9]v$h"yyo"ypVugv:s/[^a-zA-Z0-9]\+/-/g'
  normal @z

  let @z = '`<v$h"yyddk'
  normal @z

  let @z = '^hx'
  normal @z

  let $JFN = strftime("%d")."-".@y.".txt"
  echo $JFN
endfunction
:command! -range JFN :call JournalFileName() | :r!echo "$JFN" | pbcopy

