function! PullWorkToBeDoneTemplate()
  let @z=':.-1read /Users/davidvezzani/Dropbox/welfie-private/title-of-work-to-be-done.md
  normal @z
endfunction

:command! Fwork        :call PullWorkToBeDoneTemplate()
