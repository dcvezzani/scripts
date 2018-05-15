function! OpenWithMvim()
	let lineContent = getline(".")
  let fileRef = substitute(lineContent, ":.*$", "", "")
  let fileLineNumber = substitute(lineContent, "^.*:", "", "")

	if ( match( fileLineNumber, ':' ) > -1 )
		let cmd = 'mvim ~/.mnt/devstorm/'.fileRef
	else
		let cmd = 'mvim +'.fileLineNumber.' ~/.mnt/devstorm/'.fileRef
  endif
	echo fileLineNumber
	call system(cmd)
endfunction

nmap <buffer> fvo :call OpenWithMvim()<CR>

