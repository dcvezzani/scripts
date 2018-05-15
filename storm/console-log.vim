function! ConsoleLog() range
  let origPos = getpos('.')

  let line = substitute(getline("."), '^\(\s*\)\([^;]*\)\(.*\)$', '\1\2', "")
  let line = substitute(line, '[^A-Za-z0-9,][^A-Za-z0-9,]*', ' ', 'g')
  let line = substitute(line, '\s*$', '', '')

  let objListExists = (match(line, '^\([A-Za-z0-9][A-Za-z0-9]*\)\(, [A-Za-z0-9][A-Za-z0-9]*\)\{1,\}$') == 0)
	" echo 'objListExists'.objListExists

  let objExists = (match(line, '^\([A-Za-z0-9][A-Za-z0-9]*\)$') == 0)
	" echo 'objExists'.objExists

	let offset = 2
	
  if (objListExists > 0 || objExists > 0)
		let objList = substitute(line, '^\(\s*\)\(.*\)\(\s*\)$', '\2', "")
		let offset = offset + strlen('objList')
		let line = substitute(line, '^\(\s*\)\(.*\)\(\s*\)$', '\1console\.log(\["\2", \2\]);', "")
	else
		let offset = offset + strlen('obj')
		let line = substitute(line, '^\(\s*\)\(.*\)\(\s*\)$', '\1console\.log(\["\2", obj\]);', "")
  endif
	
	
  call setline(".", line)
  let newPos = [origPos[0], origPos[1], strlen(line) - offset, origPos[3]]

  " call append(".", line)
	" let newPos = [origPos[0], origPos[1]+1, strlen(line) - 5, origPos[3]]

  call setpos('.', newPos)
endfunction

vmap <buffer> qqc :call ConsoleLog()<CR>



" ^\([A-Za-z0-9][A-Za-z0-9]*\)\(, [A-Za-z0-9][A-Za-z0-9]*\)\{1,\}$
" ^\([A-Za-z0-9][A-Za-z0-9]*\)\(, [A-Za-z0-9][A-Za-z0-9]*\)\+$

" qwer
" qwer, qwer
" qwer, qwer, wert
" res redirect APP URL token token

"  asdf asdf asdf
" asdf asdf asdf
