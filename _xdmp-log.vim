function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! XdmpLog(...)
  " let @z = 'yDalet $_ := xdmp(("pA", pA))' | normal @z
  let @z = '`<' | silent! normal @z
  let origPos = getpos('.')
  let selection = s:get_visual_selection()
  let lineLength = strwidth(getline('.'))
  if (origPos[2] <= 1)
    let before = ''
  else
    let before = getline('.')[0:(origPos[2]-2)]
  endif

  let endOfLine = ((origPos[2] + len(selection)) <= lineLength)
  let xdmpLog = 'let $_ := xdmp:log((">>>'.selection.'", '.selection.'))'

  echo 'xxx: '.origPos[0].','.origPos[1].','.origPos[2].','.origPos[3].','.selection.','.len(selection).','.lineLength.','.endOfLine.','.before.','.origPos[2].',DONE'

  call setline('.', before.xdmpLog.getline('.')[(origPos[2]-1+len(selection)):-1])

  " let @z = 'gvx' | silent! normal @z
  " let @z = 'ilet $_ := xdmp:log(("'.selection.'", '.selection.'))' | silent! normal @z
  let newPos = [origPos[0], origPos[1], origPos[2] + len(xdmpLog), origPos[3]]
  call setpos('.', newPos)
  silent! startinsert!
endfunction

" unmap qd
vmap qd :call XdmpLog()<CR>
