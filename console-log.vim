function! VisualSelection()
    " if mode()=="v"
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! ConsoleLog() range
  " call search('\([' . reTermBoundaries . ']\|^\)\@<=[^' . reTermBoundaries . ']*', 'bW')
  " let line = substitute(getline("."), "^#\\+\\s*\\(.*\\)$", "\\1", "")
  " let line = substitute(getline("."), "^\\(\\s*\\)\\(.*\\)\\(\\s*\\)$", "\\1console\\.log(\\[\\"\\2\\", obj\\])", "")
  " let selectedTermInfo = MdGetSelectedTerm()

  " I'm not sure how to tell when text is selected and when it is not, so
  " here's the compromise
  " - if on different line from last selection == no selection
  let selectionChangedDifferentLine = (getpos("'<")[1] == getpos(".")[1])
  if (selectionChangedDifferentLine)
    " let selectedTermInfo = VisualSelection()
    let selectedTermInfo = substitute(VisualSelection(), '[`"]', "'", 'g')
    
  else
    let selectedTermInfo = 'trace 1'
  endif

  " let selectedTermInfo = VisualSelection()
  
  let fullPathname = expand('%')
  let currentFilename = expand('%:t')
  let currentPos = getpos(".") " [bufnum, lnum, col, off]

  let systemCommandResults = system('cat ' . fullPathname . ' | ~/scripts/parse-code-to-json.js | ~/scripts/parse-code-to-json-identify-code-blocks.js | ~/scripts/parse-code-to-json-identify-code-block-for-line.js ' . currentPos[1] . ' | ~/scripts/parse-code-to-json-identify-code-block-format-tags.sh')
  
  if (selectionChangedDifferentLine)
    let consoleLog = 'console.log(">>>dcv ('.currentFilename.', '.systemCommandResults.', '.selectedTermInfo.':'.string(currentPos[1]+1).')", '.selectedTermInfo.')'
  else
    let consoleLog = 'console.log(">>>dcv ('.currentFilename.', '.systemCommandResults.', '.selectedTermInfo.':'.string(currentPos[1]+1).')", )'
  endif

  call append(line("."), consoleLog)

  if (selectionChangedDifferentLine)
    call setpos(".", [currentPos[0], currentPos[1]+1, len(consoleLog)-(len(selectedTermInfo)), currentPos[3]])
    " let bounds = MdSelectTerm('[:space:]()\[\]<>\"', 'true')
  else
    call setpos(".", [currentPos[0], currentPos[1]+1, len(consoleLog), currentPos[3]])
  endif

  " echo 'cat ' . fullPathname . ' | ~/scripts/parse-code-to-json.js | ~/scripts/parse-code-to-json-identify-code-blocks.js | ~/scripts/parse-code-to-json-identify-code-block-for-line.js ' . currentPos[1] . ' | ~/scripts/parse-code-to-json-identify-code-block-format-tags.sh'
  
  " echo selectedTermInfo
  
  " let origPos = getpos('.')
  " let line = substitute(getline("."), '^\(\s*\)\(.*\)\(\s*\)$', '\1console\.log(\[\"\2:\", obj\])', "")
  " let lineLen = strlen(line)
  " call append(line("."), line)
  " " call setline(".", line)
  " let newPos = [origPos[0], origPos[1] + 1, lineLen - 4, origPos[3]]
  " call setpos('.', newPos)
endfunction

vmap <buffer> qqc :call ConsoleLog()<CR>
nmap <buffer> qqc :call ConsoleLog()<CR>
" unmap <buffer> qcl :call ConsoleLog()<CR>
" vunmap <buffer> qcl :call ConsoleLog()<CR>
:command! ConsoleLog :call ConsoleLog()
:command! CL :call ConsoleLog()

