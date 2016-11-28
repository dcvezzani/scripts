function! CdToIt()
  let bounds = MdSelectTerm('[:space:]\"'."'", 'true')
  let strParts = MdSplitOnBounds(getline('.'), bounds[0], bounds[1])
  let strTerm = strParts[1]

  exe 'cd' strTerm
  "let @z = '' | normal @z
  "echo 'cd' strTerm
endfunction

function! OpenIt()
  let bounds = MdSelectTerm('[:space:]\"'."'", 'false')
  let strParts = MdSplitOnBounds(getline('.'), bounds[0], bounds[1])
  let strTerm = strParts[1]

  let termColon = stridx(strTerm, ":")
  let cmd_args = ''

  if( termColon > -1 )
    let file_resource = strpart(strTerm, 0, termColon)
    let line_number = strpart(strTerm, (termColon+1))
    let cmd_args = file_resource . ' ' . line_number

  else
    let bufPattern = '^[^\"]*\"\([^\"]*\)\"[[:space:]]*line \([0-9][0-9]*\).*$'
    let file_resource = strTerm
    let line_number = substitute(getline("."), bufPattern, '\2', "")
    let @z = line_number

    if(strlen(line_number) > 0)
      let cmd_args = file_resource . ' ' . line_number

    else
      let cmd_args = strTerm
    endif
  endif

  silent execute "!~/scripts/iterm-open.sh " . cmd_args
  
  "let @z = '' | normal @z
  "echo strParts[1]
endfunction

function! OpenFile()
  let origPos = getpos('.')
  let bufPattern = '^[^\"]*\"\([^\"]*\)\"[[:space:]]*line \([0-9][0-9]*\).*$'
  let file_resource = substitute(getline('.'), bufPattern, '\1', "")
  let line_number = substitute(getline('.'), bufPattern, '\2', "")

  call setpos('.', origPos)
  silent execute "!mvim +:".string(line_number).' '.file_resource
  "echo "!mvim +:".line_number.' '.file_resource
endfunction

function! OpenFiles()
  echo ""
  let cnt = 1
  let file_names = []
  
  let line_count = line('$')
  let origPos = getpos('.')
  let line = origPos[1]
  "let @b = '$bdir/'
  while ((getline(line) !~ '^\s*$') && (line < line_count))
    let bufPattern = '^[^\"]*\"\([^\"]*\)\"[[:space:]]*line \([0-9][0-9]*\).*$'
    let file_resource = substitute(getline(line), bufPattern, '\1', "")

    if(strlen(file_resource) > 0)
      call add(file_names, file_resource)
    endif
    
    let cnt = cnt + 1
    let line = line + 1
  endwhile

  call setpos('.', origPos)
  silent execute "!mvim -p " . join(file_names, " ")
endfunction

nmap gX :call OpenIt()<CR>
nmap cd :call CdToIt()<CR>
nmap fO :call OpenFiles()<CR>
nmap fo :call OpenFile()<CR>

