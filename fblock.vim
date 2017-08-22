function! Fblock()
  let origPos = getpos('.')
	
	"methodName
  call setpos('.', origPos)
  let methodName = substitute(getline("."), '(\(.*\)$', "", "g")

	"methodArgs
  call setpos('.', origPos)
  let methodArgs = substitute(getline("."), '^[^(]\+(\([^)]\+\)).*', '\1', "g")

	if(methodArgs == getline('.'))
		let methodArgs = ''
	endif
	
	"description
  let newPos = [origPos[0], origPos[1] + 1, 0, origPos[3]]
  call setpos('.', newPos)
  call search('\n\n', 'W')
	let endPos = getpos('.')

	let descLines = []
	for i in range(newPos[1],endPos[1])
		call add(descLines, getline(i))
	endfor
	let descLines[0] = substitute(descLines[0], '^\(.*\)$', '\u\1', "g")

  call setpos('.', origPos)
	let @z = string(endPos[1] - origPos[1] + 1) . 'dd' | normal @z

  call append(line('.'), '')
  call append(line('.'), '	' . methodName . ' [ label=<<FONT FACE=' . "'times new roman bold'" . '>' . methodName . '</FONT>')
	call append(line('.') + 1, '		<br/><br/>')
	call append(line('.') + 2, '		' . descLines[0])
	call append(line('.') + 3, '		<br/><br/>')

  let newPos = [origPos[0], line('.') + 3, 0, origPos[3]]
  call setpos('.', newPos)
  let argList = split(methodArgs, ", ")
	let argListOffset = 0
	for argItem in argList
    let argParts = split(argItem, ":")
		
		call append(line('.') + argListOffset + 1, "		<FONT FACE='times new roman italic'>" . argParts[0] . '</FONT>:' . argParts[1])
		call append(line('.') + argListOffset + 2, '		<br/>')
	  let argListOffset = argListOffset + 2
	endfor
	
  let newPos = [origPos[0], line('.') + argListOffset, 0, origPos[3]]
  call setpos('.', newPos)
	call append(line('.') + 1, '		<br/>')

	let descListOffset = 2
	for descLine in descLines
		call append(line('.') + descListOffset, '		' . descLine)
		call append(line('.') + descListOffset + 1, '		<br/>')
	  let descListOffset = descListOffset + 2
	endfor
	
  let newPos = [origPos[0], line('.') + descListOffset - 1, 0, origPos[3]]
  call setpos('.', newPos)
	call append(line('.') + 1, '	> ];')

  call search('^\w', 'W')
endfunction
	
function! XFblock()
	for argItem in argList
		call append(line('.') + 1, "<FONT FACE='times new roman italic'>" . argItem . '</FONT>:UserId')
		call append(line('.') + 1, '<br/>')
	endfor
	
  let newPos = [origPos[0], origPos[1] + 5 + len(argList), 0, origPos[3]]
  call setpos('.', newPos)

	let @z = 'dd' | normal @z

	echo methodName
endfunction

nmap <buffer> qxx :call Fblock()<CR>

