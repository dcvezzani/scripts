
function! PrintBuffers()
  redir @*
  silent pwd
  silent buffers
  silent echo ''
  redir END
endfunction

:command! Fbuf        :call PrintBuffers()

