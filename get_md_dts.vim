function! GetMdDts(...)
  let $DTMD = strftime("%m/%d")
  echo $DTMD
endfunction
:command! -range DTMD :call GetMdDts() | :r!echo "$DTMD" | pbcopy


