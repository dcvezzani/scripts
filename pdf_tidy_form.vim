function! PdfTidyForm()
  let @z = '/\(^\/XFields [\)\@<=\d\+
  normal @z

  let @z = '/^'.@x.'
  normal @z

  let @z = '/\(^\/AP \)\@<=\d\+
  normal @z

  "let @z = '/^'.@c.' 0 obj
  let @z = ':%s/\('.@c.' 0 obj \n<<\)\n\/N [^\n]\+\(\n>>\)/\1\2/ge
  normal @z

  /^\/XFields
endfunction
:command! PTF :call PdfTidyForm()
