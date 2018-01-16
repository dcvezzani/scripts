" Number list items in document; match is made on numbers that start a line and
" are followed with a period.  Numbers don't actually have to be sequential.
"
" call RenumberSetup()
" nmap <buffer> qu :call Renumber('^\d\+\.\(.*\)$', '{{cnt}}.\1')<CR>
" nmap <buffer> q, :call Renumber('^\d\+\.\(.*\)$', '({{cnt}}) -\1')<CR>
" nmap <buffer> q. :call Renumber('^(\d\+) -\(.*\)$', '{{cnt}}.\1')<CR>
"
" https://cl.ly/3n2B3C473i3q/Screen%20Recording%202017-10-23%20at%2002.54%20PM.gif

" Copy to macro buffer; select and "qy
" v/\.h"wy/^\d\+\.v/\.hd"wP^

function! RenumberSetup()
	nmap <buffer> qu :call Renumber('^\d\+\.\(.*\)$', '{{cnt}}.\1')<CR>
	nmap <buffer> q, :call Renumber('^\d\+\.\(.*\)$', '({{cnt}}) -\1')<CR>
	nmap <buffer> q. :call Renumber('^(\d\+) -\(.*\)$', '{{cnt}}.\1')<CR>
endfunction

function! RenumberTeardown()
	unmap <buffer> qu
	unmap <buffer> q,
	unmap <buffer> q.
endfunction

function! RenumberReload()
	call RenumberTeardown()
	call RenumberSetup()
endfunction

function! Renumber(fromPat, toPat)
  let cnt = 0
	let fnd = -1
	let lnum = -1
	let col = -1
	let stop_lnum = -1
	let stop_col = -1

  let origPos = getpos('.')
	
	" let @z = 'v/\.h"wy/^\d\+\.v/\.hd"wP^'
	" normal @z
	
	let [lnum, col] = searchpos(a:fromPat, "W")
  while ((cnt < 50) && ((lnum != 0) && (col != 0)))
    let cnt = cnt + 1
		
		if ((lnum != 0) && (col != 0))
			let [stop_lnum, stop_col] = searchpos('\.')
			" echo [lnum, col, stop_lnum, stop_col]

			let line = getline(lnum)
			" let newLine = substitute(line, '^\d\+\.\(.*\)$', '(' . cnt . ') - \1', 'g')
			" let newLine = substitute(line, '^\d\+\.\(.*\)$', cnt . '.\1', 'g')
			let toPat = substitute(a:toPat, '{{cnt}}', cnt, 'g')
			let newLine = substitute(line, a:fromPat, toPat, 'g')
			call setline(lnum, newLine)
  		call setpos('.', [origPos[0], lnum, 0, 0])
		endif

		let [lnum, col] = searchpos(a:fromPat, "W")
  endwhile

  call setpos('.', origPos)
endfunction
