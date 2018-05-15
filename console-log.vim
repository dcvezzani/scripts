function! ConsoleLog() range
  " call search('\([' . reTermBoundaries . ']\|^\)\@<=[^' . reTermBoundaries . ']*', 'bW')
  " let line = substitute(getline("."), "^#\\+\\s*\\(.*\\)$", "\\1", "")
  " let line = substitute(getline("."), "^\\(\\s*\\)\\(.*\\)\\(\\s*\\)$", "\\1console\\.log(\\[\\"\\2\\", obj\\])", "")
  let origPos = getpos('.')
  let line = substitute(getline("."), '^\(\s*\)\(.*\)\(\s*\)$', '\1console\.log(\[\"\2:\", obj\])', "")
  let lineLen = strlen(line)
  call append(line("."), line)
  " call setline(".", line)
  let newPos = [origPos[0], origPos[1] + 1, lineLen - 4, origPos[3]]
  call setpos('.', newPos)
endfunction
vmap <buffer> qqc :call ConsoleLog()<CR>

