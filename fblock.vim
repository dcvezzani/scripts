function! Fblock()
  let origPos = getpos('.')


	"gather data

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


	"generate view

  let newPos = [origPos[0], origPos[1] - 1, 0, origPos[3]]
  call setpos('.', newPos)
	let @z = string(endPos[1] - newPos[1] + 1) . 'dd' | normal @z

  call append(line('.'), '')
  call append(line('.'), '	' . methodName . ' [ label=<<table border="0" cellpadding="0" cellspacing="0">')
	call append(line('.') + 1, '		<tr>')
	call append(line('.') + 2, '		<td colspan="2">')
	call append(line('.') + 3, '		<br/>')
	call append(line('.') + 4, '		<FONT FACE="times new roman bold">' . methodName . '</FONT>')
	call append(line('.') + 5, '		<br/><br/>')
	call append(line('.') + 6, '		' . descLines[0])
	call append(line('.') + 7, '		<br/><br/>')
	call append(line('.') + 8, '		</td>')
	call append(line('.') + 9, '		</tr>')

  let newPos = [origPos[0], line('.') + 9, 0, origPos[3]]
  call setpos('.', newPos)
  let argList = split(methodArgs, ", ")
	let argListOffset = 0
	for argItem in argList
    let argParts = split(argItem, ":")
		
		call append(line('.') + argListOffset + 1, '		<tr>')
		call append(line('.') + argListOffset + 2, '		<td align="right"><FONT FACE="times new roman italic">' . argParts[0] . '&nbsp; &nbsp; </FONT></td>')
		call append(line('.') + argListOffset + 3, '		<td align="left">&nbsp; &nbsp; ' . argParts[1] . '</td>')
		call append(line('.') + argListOffset + 4, '		</tr>')
	  let argListOffset = argListOffset + 4
	endfor
	
  let newPos = [origPos[0], line('.') + argListOffset, 0, origPos[3]]
  call setpos('.', newPos)
	call append(line('.') + 1, '		<tr>')
	call append(line('.') + 2, '		<td colspan="2" align="left">')

	let descListOffset = 3
	for descLine in descLines
		call append(line('.') + descListOffset, '		<br align="left"/>')
		call append(line('.') + descListOffset + 1, '		' . descLine)
	  let descListOffset = descListOffset + 2
	endfor
	
  let newPos = [origPos[0], line('.') + descListOffset - 1, 0, origPos[3]]
  call setpos('.', newPos)
	call append(line('.') + 1, '		<br align="left"/>&nbsp;<br/>&nbsp;')
	call append(line('.') + 2, '		</td>')
	call append(line('.') + 3, '		</tr>')
	call append(line('.') + 4, '		</table>')
	call append(line('.') + 5, '	> ];')

  call search('^\w', 'W')
endfunction

function! Qgen()
endfunction

nmap <buffer> qxx :call Fblock()<CR>
:command! QGEN :call Qgen() | :r!/Users/dcvezzani/scripts/generateDot.sh "%"


