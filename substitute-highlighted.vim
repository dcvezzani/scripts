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

function! CopyGrep() range
  " let selectedTermInfo = NMdGetSelectedTerm()
	" echo selectedTermInfo

	" let selectedTerm = selectedTermInfo[0]
	" let startPos = selectedTermInfo[1]
	let startPos = 0
  let origPos = getpos('.')

	let selectedTerm = getline('.')
	let curLine = line('.')

	call setpos('.', [origPos[0], curLine, startPos, origPos[3]])
	call setline('.', '### '.selectedTerm)
  " startinsert!
	call append(line('.'), '')
	call append(line('.'), '')
	call setpos('.', [origPos[0], curLine+1, startPos, origPos[3]])
	
  " let $GREP_CMD = "ssh devstorm '".'grep -e " ls" -e "Light" -e "light" -e "LIGHT" -e "comet" -e "Comet" -e "COMET" '.selectedTerm
  let $GREP_CMD = '/Users/dcvezzani/scripts/grep_cmd.sh "'.selectedTerm.'"'
  let $COPY_GREP_CMD = $GREP_CMD."' | pbcopy"

	let matchingLines = systemlist('eval /Users/dcvezzani/scripts/grep_cmd.sh "'.selectedTerm.'"')
	" echo '>>>'.matchingLines[0]

	call append(line('.'), '```')

	let cnt = 0
	for line in matchingLines
			call append(line('.'), line)
			let cnt += 1
	endfor
	call append(line('.'), '```')

	let curLine = line('.')
	call setpos('.', [origPos[0], (curLine+cnt+4), startPos, origPos[3]])
	
	" call setline('.', matchingLines)

endfunction

" Shortcuts
vmap <buffer> qnr :call SubstituteHighlighted()<CR>
:command! -range QNC :call CopyGrep() | :r!echo "$COPY_GREP_CMD" | pbcopy
vmap <buffer> qnc :QNC<CR>
nmap <buffer> qnc :QNC<CR>

