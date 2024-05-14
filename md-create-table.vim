"function! s:get_visual_selection()
" function! GetVisualSelection()
"     " Why is this not a built-in Vim script function?!
"     let [line_start, column_start] = getpos("'<")[1:2]
"     let [line_end, column_end] = getpos("'>")[1:2]
"     let lines = getline(line_start, line_end)
"     if len(lines) == 0
"         return ''
"     endif
"     let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
"     let lines[0] = lines[0][column_start - 1:]
"     return join(lines, "\n")
" endfunction

" xnoremap <leader>a :<C-U> call GetVisualSelection(visualmode())<Cr>

function! GetVisualSelection(mode) range
    " call with visualmode() as the argument
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end]     = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if a:mode ==# 'v'
        " Must trim the end before the start, the beginning will shift left.
        let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
        let lines[0] = lines[0][column_start - 1:]
    elseif  a:mode ==# 'V'
        " Line mode no need to trim start or end
    elseif  a:mode == "\<c-v>"
        " Block mode, trim every line
        let new_lines = []
        let i = 0
        for line in lines
            let lines[i] = line[column_start - 1: column_end - (&selection == 'inclusive' ? 1 : 2)]
            let i = i + 1
        endfor
    else
        return ''
    endif
    " for line in lines
    "     echom line
    " endfor
    return join(lines, "\n")
endfunction


function! CreateTable() range
  let @w = GetVisualSelection(visualmode())
  let @z = 'gvdk' | normal @z

  execute 'r! ~/scripts/cat-to-file.sh '.shellescape(@w, 1).' ~/scripts/md-create-table.js 2>/dev/null'
endfunction

xnoremap qtc :<C-U> call CreateTable()<Cr>


