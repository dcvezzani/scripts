function! JsTestsDisable()
  let origPos = getpos('.')
	let @z = ':%s/^\( *\)it(/\1xit(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

function! JsTestsEnable()
  let origPos = getpos('.')
	let @z = ':%s/^\( *\)xit(/\1it(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

:command! JsTestsDisable            :call JsTestsDisable()
:command! JsTestsEnable             :call JsTestsEnable()

