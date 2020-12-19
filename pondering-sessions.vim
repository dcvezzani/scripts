function! CreatePonderingSession()
  :read /Users/dcvezzani/Dropbox/journal/current/20200906-pondering-session-template.md

  let @z = 'ggdd' | normal @z
endfunction

:command! Psession :call CreatePonderingSession()

