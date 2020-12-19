" http://stackoverflow.com/questions/18752516/how-to-automatically-name-a-file-when-saving-in-vim
function! FontApplyIt()
  let vim_fontapply=$VIM_FONTAPPLY

  if vim_fontapply == 'true'
    set guifont=Menlo:h18
  else
    set guifont=Menlo:h14
  endif
endfunction

function! ToggleFontApply()
  let vim_fontapply=$VIM_FONTAPPLY

  if vim_fontapply == 'true'
    let $VIM_FONTAPPLY = 'false'
  else
    let $VIM_FONTAPPLY = 'true'
  endif

  let vim_fontapply=$VIM_FONTAPPLY
  echo "VIM_FONTAPPLY: ".vim_fontapply
endfunction
nmap fs :call ToggleFontApply()<CR>

autocmd BufLeave,FocusLost * silent! call FontApplyIt()

"nnoremap rm :call delete(expand('%')) \| bdelete!<CR>
"nnoremap rm :call delete(expand('%'))<CR>
" nmap rrm :call delete(expand('%')) \| bdelete!<CR>
" nmap rm :call delete(expand('%')) \| echo("file deleted")<CR>
"nmap rm :call delete(expand('%'))<CR>

