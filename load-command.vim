function! LoadCommand(cmdName) range
  " echo "firstline ".a:firstline." lastline ".a:lastline
  " echo "firstline contents" . getline(a:firstline)
  " echo "lastline contents" . getline(a:lastline)

  let cmd = ':echo "hi"'
  if (a:cmdName == "quote")
    let @z = 'V:s/^.*$/"\0"/ggv:s/""//g'
  endif

  let curline = a:firstline
  while (curline < (a:lastline + 1))
    let origPos = getpos('.')
    let newPos = [origPos[0], curline, origPos[2], origPos[3]]
    call setpos('.', newPos)
    " echo "curline contents" . getline(curline)

    let line = getline(curline)
    silent exec "normal @z"

    let curline = curline + 1
  endwhile
endfunction

command! -range LCquote <line1>,<line2>call LoadCommand("quote")
