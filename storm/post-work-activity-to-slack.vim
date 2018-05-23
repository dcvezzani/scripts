function! SendWorkActivity() range
  let lastLine = line("'>")
  let firstLine = line("'<")
  let curLine = firstLine
	let fullLine = ''

  while (curLine <= lastLine)
		let line = getline(curLine)
		let fullLine = fullLine . "\n" . line
		let curLine = curLine + 1
	endwhile

	" echo '"' . fullLine . '"| slackcat --channel storm-x --stream'
endfunction

function! FormatWorkActivity() range
  let origPos = getpos('.')

	" :s/^\([^\t ]\+\)[\t ]\+\([^\t ]\+\)[\t ]\+\(.*\)$/\1:\2:\3/ggv:!column -t -s:gv

  let lastLine = line("'>")
  let firstLine = line("'<")
  let curLine = firstLine

  while (curLine <= lastLine)
		let line = substitute(getline(curLine), ':', ';', 'g')
		let line = substitute(line, '^\([^\t ]\+\)[\t ]\+\([^\t ]\+\)[\t ]\+\(.*\)$', '\1:\2:\3', 'g')
		call setline(curLine, line)
		let curLine = curLine + 1
	endwhile

  call append(firstLine-1, '```')
  call append(lastLine+1, '```')

  " call append(firstLine-1, 'echo "```')
  " call append(lastLine+1, '```" | slackcat --channel storm-daily --stream')

	normal! 'gv:!column -t -s:'

	call setpos('.',[0,(firstLine),0])
	normal! V
	call setpos('.',[0,(lastLine+2),0])

  " call setpos('.', origPos)
endfunction

vmap <buffer> qqa :call FormatWorkActivity()<CR>
" vmap <buffer> qqas :call SendWorkActivity()<CR>



" ^\([A-Za-z0-9][A-Za-z0-9]*\)\(, [A-Za-z0-9][A-Za-z0-9]*\)\{1,\}$
" ^\([A-Za-z0-9][A-Za-z0-9]*\)\(, [A-Za-z0-9][A-Za-z0-9]*\)\+$

" qwer
" qwer, qwer
" qwer, qwer, wert
" res redirect APP URL token token

"  asdf asdf asdf
" asdf asdf asdf
