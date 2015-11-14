function! PdfNavigate(...)
  if(a:0 > 0 && strlen(a:1) > 0 && a:1 == 'obj')
    let @z = '? /\dvw/ h"jy' | normal @z
    call search('^' . @j . ' obj')
  else
    let @z = '? /\dvw/ h"ky' | normal @z
    call search('\([\n \[]\)\@<=' . @k . ' R\([\n \]]\)\@=')
  endif
endfunction

nmap <buffer> pob :call PdfNavigate('obj')<CR>
nmap <buffer> por :call PdfNavigate('ref')<CR>

let b:current_syntax = "pdf"
