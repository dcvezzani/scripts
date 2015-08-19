function! Dcvcols01(...)
  let z=':s/: \+/ç/ggv:!column -t -s "ç"'
  normal @z
endfunction

nnoremap <C-S-X>col    :call Dcvcols()
:command! -range COL   :call Dcvcols()

  let z=':s/: \+/ç/ggv:!column -t -s "ç"'
:s/\(:\d\+\) \+/\1ç/ggv:!column -t -s "ç"

