function! PrintBuffers(copyToClipBoard)
  redir @z
  silent pwd
  silent buffers
  silent echo ''
  redir END

  "let dts=substitute(system('date +\%Y\%m\%d'), '\n\+$', '', 'g')
  let dts=substitute(system('date +\%F-\%a | perl -ne "print lc"'), '\n\+$', '', 'g')
  let fname=$JOURNAL_DIR.'/current/fbuf-' . dts . '.md'
  silent execute '!touch ' . fname
  
  execute 'redir >> ' . fname
    let blk = substitute(''.@z, '^\n\+', '', 'g')
    silent echo blk
  redir END

  if(a:copyToClipBoard == 'true')
    let @* = blk
  endif
endfunction

:command! Fbuf        :call PrintBuffers('false')
:command! Fbufc        :call PrintBuffers('true')

