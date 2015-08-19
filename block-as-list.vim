
function! CreateBlockAsList()
  let @z = '^v/^$kV,ul>li*v/ul>nV</^$/^.kj' | normal @z
  " let @x = 'kjk^' | normal @x
endfunction

nnoremap <C-S-X>lst  :call CreateBlockAsList()
:command! LST        :call CreateBlockAsList()

