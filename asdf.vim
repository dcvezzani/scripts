function! PrependTableSchemaColumn(...)
  let @z = '$v^"uyjjjjV/^+k'
  normal @z

  let @z = ':s/^/'.@u.' /gjjj'
  normal @z
endfunction
:command! -range PTSC :call PrependTableSchemaColumn()

