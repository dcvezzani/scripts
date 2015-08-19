"broken as of Thu Apr 16 15:43:22 PDT 2015; consider getting rid of this
"
function! MoveFileNotice(...)
  "let @z = '`</[a-zA-Z0-9]v$h"yyo"ypVugv:s/[^a-zA-Z0-9]\+/-/g'
  let @z = '`<v/$h"yyo"ypVugv:s/[^a-zA-Z0-9]\+/-/g'
  normal @z

  let @z = '`<v$h"yyddk'
  normal @z

  "let $JFN = strftime("%d")."-".@y.".txt"
  let $MFN = @y.".txt"."\nopen \"/Volumes/Extra/filename\" \nopen \"/Volumes/Extra/\" > \"filename.txt\""
  
  echo $MFN
endfunction
:command! -range MFN :call MoveFileNotice() | :r!echo "$MFN" | pbcopy


