function! PdfTidyForm()
  let @z = '/\(^\/XFields [\)\@<=\d\+v/\(R\)\@<="wygvxo"wpV:s/0 R.*/0 obj/g$v^"xydd'
  normal @z

  let @z = '/^'.@x.'kj'
  normal @z

  let @z = '/\(^\/AP \)\@<=\d\+v/ h"cy'
  normal @z

  "let @z = '/^'.@c.' 0 objkj'
  let @z = ':%s/\('.@c.' 0 obj \n<<\)\n\/N [^\n]\+\(\n>>\)/\1\2/ge'
  normal @z

  /^\/XFields
endfunction
:command! PTF :call PdfTidyForm()

