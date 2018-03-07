function! PrintBuffers()
  redir @z
  silent pwd
  silent buffers
  silent echo ''
  redir END

  let dts=substitute(system('date +\%Y\%m\%d'), '\n\+$', '', 'g')
	" let fname='/Users/dcvezzani/Documents/journal/current/fbuf-' . dts . '.md'
  let fname=$JOURNAL_DIR.'/current/fbuf-' . dts . '.md'
  silent execute '!touch ' . fname
  
  execute 'redir >> ' . fname
    let blk = substitute(''.@z, '^\n\+', '', 'g')
    silent echo blk
  redir END
endfunction

:command! Fbuf        :call PrintBuffers()

