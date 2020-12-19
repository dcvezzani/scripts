" http://stackoverflow.com/questions/18752516/how-to-automatically-name-a-file-when-saving-in-vim
function! SaveIt()
  let vim_autosave=$VIM_AUTOSAVE
  let file_extension='md'

  if vim_autosave == 'true'
    let one_line = (line("$") < 2)

    if getfsize(expand(@%)) == 0 || (one_line && strwidth(getline('.')) == 0)
      return
    endif

    if bufname("%")==''
      let origPos = getpos('.')
      let @z = 'gg$v^"wy' | normal @z

      let newLine = substitute("".@w, "[\\n\\r]", "", "g")
      
      if strlen("".newLine) > 0

        " if match(newLine, "[^a-zA-Z0-9]\\+txt$") > -1
				let reExtensionDefined = "\\.\\([a-zA-Z0-9]\\{2,5\\}\\)$"
        let matchedItems = matchlist(newLine, reExtensionDefined)
        if len(matchedItems) > 0
					let chk_file_extension = get(matchedItems, 1)
					if strlen(chk_file_extension) > 0
						let file_extension = chk_file_extension
						let newLine = substitute(newLine, "\\.[^\\.]*$", "", "")
					endif
        endif
      
        let maxFileNameLength = 40
        if strlen("".newLine) > maxFileNameLength 
          let newLine = strpart(''.newLine, 0, maxFileNameLength)
        endif

        "echo "".newLine
        "let newLine = substitute(getline("."), "^\*\\s*\\(.*\\)$", "\\1", "")
        let newLine = substitute("".newLine, "[^a-zA-Z0-9]\\+", "-", "g")
        let newLine = substitute(newLine, "^-\\+\\|-\\+$", "", "")
        let newLine = tolower(newLine)

        let dts = strftime('%Y%m%d')
        let newLine = $JOURNAL_DIR.'/current/'.dts.'-'.newLine.'.'.file_extension

        if one_line
          "call setpos(origPos[0], origPos[1], origPos[2], origPos[3])
          let @z = 'o' | normal @z

        else
          let @z = 'O' | normal @z
          call setline(line("."), '<div style="display:none">')
          let @z = 'o' | normal @z
          call setline(line("."), newLine)
          let @z = 'o' | normal @z
          call setline(line("."), '</div>')
          let @z = 'oA' | normal @z
          call setline(line("."), '<style>')
          let @z = 'o' | normal @z
          call setline(line("."), '  ul { list-style: inherit; }')
          let @z = 'o' | normal @z
          call setline(line("."), '</style>')
          let @z = 'o' | normal @z
          call setline(line("."), '')
					let origPos = [origPos[0], (origPos[1]+6), 0, origPos[3]]
        endif

        " copy to clipboard if desired
        let @+ = newLine
        echo "".newLine

        " go back to original position
        call setpos('.', origPos)
        exec 'w '.newLine

      else
        exec 'w '"${JOURNAL_DIR}/current"'/note_'.localtime().'.'.file_extension
      endif

      call PrintBuffers()
    
    " if file already has a name, just save it
    " else
    "   w
    endif
  endif
endfunction

function! ToggleSaveIt()
  let vim_autosave=$VIM_AUTOSAVE

  if vim_autosave == 'true'
    let $VIM_AUTOSAVE = 'false'
  else
    let $VIM_AUTOSAVE = 'true'
  endif

  let vim_autosave=$VIM_AUTOSAVE
  echo "VIM_AUTOSAVE: ".vim_autosave
endfunction
nmap gs :call ToggleSaveIt()<CR>

autocmd BufLeave,FocusLost * silent! call SaveIt()

"nnoremap rm :call delete(expand('%')) \| bdelete!<CR>
"nnoremap rm :call delete(expand('%'))<CR>
nmap rrm :call delete(expand('%')) \| bdelete!<CR>
nmap rm :call delete(expand('%')) \| echo("file deleted")<CR>
"nmap rm :call delete(expand('%'))<CR>

