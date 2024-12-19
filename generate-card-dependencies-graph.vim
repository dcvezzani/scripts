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

function! SetOutputFile() range
  let $OUTPUT_FILE = substitute(GetVisualSelection(visualmode()), '[\r\n].*', '', '')
  
  " execute 'r! ~/scripts/cat-to-file.sh '.shellescape(@w, 1).' ~/scripts/jira-create-new-card-request.js 2>/dev/null'
  echo 'Set OUTPUT_FILE to '.$OUTPUT_FILE
endfunction

function! GenerateCardDependenciesGraph() range
  let $WRAP_MIN = "13"

  let @w = GetVisualSelection(visualmode())
  " let @z = 'gvdk' | normal @z

  " execute 'r! ~/scripts/cat-to-file.sh '.shellescape(@w, 1).' ~/scripts/generate-card-dependencies-graph.js 2>/dev/null | dot -Tpng > "$OUTPUT_FILE"; open "$OUTPUT_FILE"'
  execute 'r! ~/scripts/cat-to-file.sh '.shellescape(@w, 1).' ~/scripts/generate-card-dependencies-graph.js >/dev/null 2>&1'
endfunction

function! GenerateCardDependenciesGraphCode() range
  let $WRAP_MIN = "13"

  let @w = GetVisualSelection(visualmode())
  let @z = 'gvdk' | normal @z

  execute 'r! GENERATE_CODE=true ~/scripts/cat-to-file.sh '.shellescape(@w, 1).' ~/scripts/generate-card-dependencies-graph.js'
endfunction

xnoremap qtt :<C-U> call GenerateCardDependenciesGraph()<Cr>
xnoremap qty :<C-U> call GenerateCardDependenciesGraphCode()<Cr>
xnoremap qte :<C-U> call SetOutputFile()<Cr>





