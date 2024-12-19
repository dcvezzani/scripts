" so /Users/dcvezzani/scripts/substitute-highlighted.vim

function! NMdGetSelectedTerm()
  let selectedTerm = strpart(getline('.'), col("'<")-1, col("'>")-(col("'<")-1))
  let startPos = col("'<")
  let endPos = col("'>")
  return [selectedTerm, startPos, endPos]
endfunction

function! SubstituteHighlighted() range
  let selectedTermInfo = NMdGetSelectedTerm()
	" echo selectedTermInfo

	let selectedTerm = selectedTermInfo[0]
	let startPos = selectedTermInfo[1]
  let origPos = getpos('.')
	let curLine = line('.')

  call inputsave()
  let replaceTerm = input('Replace "'.selectedTerm.'" with: ')
  call inputrestore()
	
	" echo "\n"

	let l = 1
	for line in getline(1,"$")
			call setline(l, substitute(line, selectedTerm, replaceTerm, "g"))
			let l = l + 1
	endfor

	call setpos('.', [origPos[0], curLine, startPos, origPos[3]])
endfunction

" function! CopyGrep() range
"   " let selectedTermInfo = NMdGetSelectedTerm()
" 	" echo selectedTermInfo

" 	" let selectedTerm = selectedTermInfo[0]
" 	" let startPos = selectedTermInfo[1]
" 	let startPos = 0
"   let origPos = getpos('.')

" 	let selectedTerm = getline('.')
" 	let curLine = line('.')

" 	call setpos('.', [origPos[0], curLine, startPos, origPos[3]])
" 	call setline('.', '### '.selectedTerm)
"   " startinsert!
" 	call append(line('.'), '')
" 	call append(line('.'), '')
" 	call setpos('.', [origPos[0], curLine+1, startPos, origPos[3]])
	
"   " let $GREP_CMD = "ssh devstorm '".'grep -e " ls" -e "Light" -e "light" -e "LIGHT" -e "comet" -e "Comet" -e "COMET" '.selectedTerm
"   let $GREP_CMD = '~/scripts/grep_cmd.sh "'.selectedTerm.'"'
"   let $COPY_GREP_CMD = $GREP_CMD."' | pbcopy"

" 	let matchingLines = systemlist('eval ~/scripts/grep_cmd.sh "'.selectedTerm.'"')
" 	" echo '>>>'.matchingLines[0]

" 	call append(line('.'), '```')

" 	let cnt = 0
" 	for line in matchingLines
" 			call append(line('.'), line)
" 			let cnt += 1
" 	endfor
" 	call append(line('.'), '```')

" 	let curLine = line('.')
" 	call setpos('.', [origPos[0], (curLine+cnt+4), startPos, origPos[3]])
	
" 	" call setline('.', matchingLines)

" endfunction

function! CopyGrep2(type) range
  let lineNum = line('.')
	let selectedTerm = getline(lineNum)

  if (a:type == 'file-list')
    let grepFlags = 'l'
  else
    let grepFlags = 'n'
  endif

  let $GREP_CMD = '~/scripts/grep_cmd.sh "'.selectedTerm.'"'
  let $COPY_GREP_CMD = $GREP_CMD."' | pbcopy"
  let CMD = 'eval ~/scripts/grep_cmd.sh "'.selectedTerm.'"'.' "'.grepFlags.'"'
	let matchingLines = systemlist(CMD)
  
	call setline(lineNum, '### '.selectedTerm.' ('.len(matchingLines).' matches)')
  
	let cnt = 0
	let idx = 0
  let maxCnt = 100

	call append(lineNum + cnt, '```')
	let cnt += 1

  while idx < len(matchingLines) && idx < maxCnt
	" for line in matchingLines
		let line = matchingLines[idx]
		call append(lineNum + cnt, line)
		let idx += 1
		let cnt += 1
	" endfor
  endwhile

	call append(lineNum + cnt, '```')
	let cnt += 1

	call append(lineNum + cnt, '')
	let cnt += 1

  return lineNum + cnt + 1
endfunction

function! CopyGrep2Vis(type) range
  let start_row = line("'<")
  let stop_row = line("'>")
  let cnt = start_row
  let origPos = getpos('.')

  call setpos('.', [origPos[0], cnt, origPos[2], origPos[3]])

  while cnt <= stop_row
    let rowPos = CopyGrep2(a:type)
    " echo rowPos
    call setpos('.', [origPos[0], rowPos, origPos[2], origPos[3]])
    let cnt += 1
  endwhile
  call setpos('.', origPos)
endfunction

" function! CopyGrep2Aux(start_row, stop_row) range
"   call append(a:start_row, '<div style="display: none;">')
"   call append(a:stop_row, '</div>')
" endfunction


" Shortcuts
vmap <buffer> qnr :call SubstituteHighlighted()<CR>
" :command! -range QNC :call CopyGrep() | :r!echo "$COPY_GREP_CMD" | pbcopy
vmap <buffer> qnc :call CopyGrep2Vis("line-numbers")<CR>
vmap <buffer> qnl :call CopyGrep2Vis("file-list")<CR>
" nmap <buffer> qnc :QNC<CR>

