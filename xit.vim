function! JsTestsDisable()
  let origPos = getpos('.')
	let @z = ':%s/^\([ 	]*\)\(it\|test\)(/\1x\2(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

function! JsTestsEnable()
  let origPos = getpos('.')
	let @z = ':%s/^\([ 	]*\)x\(it\|test\)(/\1\2(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

function! JsDescribesDisable()
  let origPos = getpos('.')
	let @z = ':%s/^\([ 	]\+\)describe(/\1xdescribe(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

function! JsDescribesEnable()
  let origPos = getpos('.')
	let @z = ':%s/^\([ 	]\+\)xdescribe(/\1describe(/g'
	normal @z
  call setpos('.', [origPos[0], origPos[1], origPos[2], origPos[3]])
endfunction

:command! JsTestsDisable            :call JsTestsDisable()
:command! JsTestsEnable             :call JsTestsEnable()
:command! JsDescribesDisable            :call JsDescribesDisable()
:command! JsDescribesEnable             :call JsDescribesEnable()
:command! Jstd                      :call JsTestsDisable()
:command! Jste                      :call JsTestsEnable()
:command! Jsdd            :call JsDescribesDisable()
:command! Jsde             :call JsDescribesEnable()
nmap <buffer> qjd :call JsTestsDisable()<CR>
nmap <buffer> qje :call JsTestsEnable()<CR>

