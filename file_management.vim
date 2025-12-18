let s:MAX_FILE_NAME_LENGTH = 100

" http://stackoverflow.com/questions/18752516/how-to-automatically-name-a-file-when-saving-in-vim
function! SaveFile()
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
      
        if strlen("".newLine) > s:MAX_FILE_NAME_LENGTH 
          let newLine = strpart(''.newLine, 0, s:MAX_FILE_NAME_LENGTH)
        endif

        "echo "".newLine
        "let newLine = substitute(getline("."), "^\*\\s*\\(.*\\)$", "\\1", "")
        let newLine = substitute("".newLine, "[^a-zA-Z0-9]\\+", "-", "g")
        let newLine = substitute(newLine, "^-\\+\\|-\\+$", "", "")
        let newLine = tolower(newLine)

        let dts = strftime('%Y%m%d')
        let newLine = $JOURNAL_DIR.'/current/'.dts.'-'.newLine.'.'.file_extension
        let isMd = match(newLine, "\.md$")

        " copy to clipboard if desired
        " let @+ = newLine
        " echo "".newLine

        " go back to original position
        call setpos('.', origPos)
        exec 'w '.newLine

      else
        exec 'w '"${JOURNAL_DIR}/current"'/note_'.localtime().'.'.file_extension
      endif

      call PrintBuffers('false')
    
    " if file already has a name, just save it
    " else
    "   w
    endif
  endif
endfunction

function! ToggleSaveFile()
  let vim_autosave=$VIM_AUTOSAVE

  if vim_autosave == 'true'
    let $VIM_AUTOSAVE = 'false'
  else
    let $VIM_AUTOSAVE = 'true'
  endif

  let vim_autosave=$VIM_AUTOSAVE
  echo "VIM_AUTOSAVE: ".vim_autosave
endfunction
nmap gs :call ToggleSaveFile()<CR>

autocmd BufLeave,FocusLost * silent! call SaveFile()

"nnoremap rm :call delete(expand('%')) \| bdelete!<CR>
"nnoremap rm :call delete(expand('%'))<CR>
nmap rrm :call delete(expand('%')) \| bdelete!<CR>
nmap rm :call delete(expand('%')) \| echo("file deleted")<CR>
"nmap rm :call delete(expand('%'))<CR>

