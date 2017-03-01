function! PrintBuffersReport()
  call PrintBuffers()
  let filename = '/Users/davidvezzani/Dropbox/journal/current/file-log.txt'
  let buf = ''.@*.''
  "echo chk
  "let cleanstr = substitute( buf, ' ', '\r', 'g')
  "let cleanstr = substitute( buf, '', '\r', 'g')
  call writefile(readfile(filename)+[buf], filename)

  echo winnr('$')
  let @z = ':wincmd 1'
  normal @z
endfunction

":command! Fbufr        :call PrintBuffersReport()
