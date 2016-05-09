function! PdfNavigate(...)
  if(a:0 > 0 && strlen(a:1) > 0 && a:1 == 'obj')
    let @z = '? 
    call search('^' . @j . ' obj')
  else
    let @z = '? 
    call search('\([\n \[]\)\@<=' . @k . ' R\([\n \]]\)\@=')
  endif
endfunction

" nmap <buffer> qobj :call PdfNavigate('obj')<CR>
" nmap <buffer> qref :call PdfNavigate('ref')<CR>
" unmap <buffer> qobj
" unmap <buffer> qref
nmap <buffer> qo :call PdfNavigate('obj')<CR>
nmap <buffer> qr :call PdfNavigate('ref')<CR>

let b:current_syntax = "pdf"