function! StrCap()
  let curPos = getpos('.')
  let content = getline('.')
  let preTerm = strpart(content, 0, col("'<")-1)
  let term = substitute(strpart(content, col("'<")-1, col("'>") - col("'<")), '\v<(.)(\w*)', '\u\1\L\2', 'g')
  let postTerm = strpart(content, col("'>")-1, strlen(content) )

  call setline('.', preTerm . term . postTerm)
  call setpos('.', [curPos[0], curPos[1], col("'<"), curPos[3]])

  let @z = 'gv' | normal @z
endfunction

function! StrWords(...)
  call StrUpdateSelectedString('[^[:alnum:]]\+', ' ')

  if a:0 > 0 && a:1 =~ '^cap'
    call StrCap()
  endif
endfunction

function! StrUpdateSelectedString(pattern, replace)
  let curPos = getpos('.')
  let content = getline('.')
  let preTerm = strpart(content, 0, col("'<")-1)
  let term = substitute(strpart(content, col("'<")-1, col("'>") - col("'<")), a:pattern, a:replace, 'g')
  let postTerm = strpart(content, col("'>")-1, strlen(content) )

  call setline('.', preTerm . term . postTerm)
  call setpos('.', [curPos[0], curPos[1], col("'<"), curPos[3]])

  let @z = 'gv' | normal @z
endfunction

vmap <buffer> sc :call StrCap()<CR>
vmap <buffer> sw :call StrWords()<CR>
vmap <buffer> swc :call StrWords('capitalize')<CR>
vmap <buffer> scw :call StrWords('capitalize')<CR>
