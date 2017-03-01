
" Collect story information for a given user
"
" ![image](https://cloud.githubusercontent.com/assets/218810/23479817/8d34a924-fe7a-11e6-8ed5-005780dd7e5b.png)
"
" * paste in the html block with stories for sprint
" * place cursor anywhere in the block of html
" * 'qpf' to compile the lines, total the points and collect the story numbers

function! ReformatPtStoriesFor(owner)
  " s/<div/\r\0/g
  " s/^\(\(.*(134, 134, 134).*\)\|\(.*>DV<.*\)\)$/x \0/g
  " v/^x /d
  " s/\(<\/div>\)[\r\n]\+\(x <div style=\"width\)/\1<br>\2/ge
  " v/<br>x /d
  " s/^.\{-}rgb(134, 134, 134).\{-}>\([^p]\+\)pts.\{-}-->\([^<]\+\)\(<!--[^>]\+>[^<]*\)\{3\}\(<.\?a[^>]*>[^<]*\)\{2\}\(<!--[^>]\+>[^<]*\)\{4\}<a href=\"\/story\/show\/\([^\"]\+\)\".*/\1, #\6: \2/ge
  
  " @z = 'ombkkmajV:s/<div/\r\0/g\`ajv`bk$\k$:s/^\(\(.*(134, 134, 134).*\)\|\(.*>DV<.*\)\)$/x \0/g\`ajv`bk$\k$:v/^x /d\`ajv`bk$\k$:s/\(<\/div>\)[\r\n]\+\(x <div style=\"width\)/\1<br>\2/ge\`ajv`bk$\k$:v/<br>x /d\`ajv`bk$\k$:s/^.\{-}rgb(134, 134, 134).\{-}>\([^<]\+\).\{-}-->\([^<]\+\)\(<!--[^>]\+>[^<]*\)\{3\}\(<.\?a[^>]*>[^<]*\)\{2\}\(<!--[^>]\+>[^<]*\)\{4\}<a href=\"\/story\/show\/\([^\"]\+\)\".*/\1, #\6: \2/ge\`a'
  " normal @z

  let curPos = getpos('.')
  call setpos('.', [curPos[0], curPos[1], 0, 0])
  " echo strlen(getline("."))
  let new_lines = split(substitute(getline('.'), '<div', '\r\0', 'g'), '\r')
  " let @z = 'dd' | normal @z
  " call append((line(".")), new_lines )

  let new_lines_buffer = []
  let line_count = len(new_lines)
  let cnt = 0
  let re = '^\(\(.*(134, 134, 134).*\)\|\(.*>'.a:owner.'<.*\)\)$'
  while (cnt < line_count)
    let new_line = new_lines[cnt]

    let mpos = match(new_line, re)
    if(mpos > -1)
      let new_lines_buffer += [new_line]
    endif
    let cnt += 1
  endwhile
  let new_lines = new_lines_buffer
  " echo new_lines[0].':'.len(new_lines)

  let new_lines_buffer = []
  let line_count = len(new_lines)
  let cnt = 0
  let re_pts = '<div style=\"font-size'
  let re_story = '<div style=\"width'
  let peek_pts = []
  while (cnt < line_count)
    let new_line = new_lines[cnt]

    if(match(new_line, re_pts) > -1)
      let peek_pts += [new_line]
    endif

    if(match(new_line, re_story) > -1)
      let pts = peek_pts[len(peek_pts)-1]
      let new_lines_buffer += [pts.new_line]
      let peek_pts = []
    endif
    let cnt += 1
  endwhile
  let new_lines = new_lines_buffer
  " echo new_lines[0].':'.len(new_lines)

  let new_lines_buffer = []
  let line_count = len(new_lines)
  let cnt = 0
  let re = '^.\{-}rgb(134, 134, 134).\{-}>\([^p]\+pts\?\).\{-}-->\([^<]\+\)\(<!--[^>]\+>[^<]*\)\{3\}\(<.\?a[^>]*>[^<]*\)\{2\}\(<!--[^>]\+>[^<]*\)\{4\}<a href=\"\/story\/show\/\([^\"]\+\)\".*'

  while (cnt < line_count)
    let new_line = substitute(new_lines[cnt], re, '\1, #\6: \2', 'g')
    let new_lines_buffer += [new_line]
    let cnt += 1
  endwhile
  let new_lines = new_lines_buffer
  " echo new_lines[0].':'.len(new_lines)

  exe 'normal dd'
  call append((line(".")), new_lines + [''] )

  call PtListStoryNumbers('n')
  call PtAddPoints('n')
endfunction

function! PtAddPoints(mode) range
  " let re = "^\\([^p]\\+\\)pt.\*$"
  let re = '^\([^p]\+\)pts\?.*$'

  if a:mode == 'v'
    let start_line = line("'<")
    let end_line = line("'>")
    let end_offset = 1
    let closing_offset = 1

  else
  " if a:mode == 'n'
    call search('^$', 'bW')
    call search(re, 'W')
    let start_line = line(".")
    call search('^$', 'W')
    call search(re, 'bW')
    let end_line = line(".")
    let end_offset = 2
    let closing_offset = 0
  endif

  let curPos = getpos('.')
  call setpos('.', [curPos[0], start_line, 0, 0])
  let points = 0
  
  while (line('.') <= end_line)
    let points = str2nr(substitute(getline("."), re, "\\1", "")) + points
    call setpos('.', [curPos[0], (line('.')+1), 0, 0])
  endwhile
  
  call append((line(".")-1), [ points ] )
  call setpos('.', [curPos[0], (end_line + 1), 0, 0])
endfunction

function! PtListStoryNumbers(mode) range
  let re = '^[^#]\+\(#[^:]\+\):.*$'
  if a:mode == 'v'
    let start_line = line("'<")
    let end_line = line("'>")
    let end_offset = 1
    let closing_offset = 1

  else
  " if a:mode == 'n'
    call search('^$', 'bW')
    call search(re, 'W')
    let start_line = line(".")
    call search('^$', 'W')
    call search(re, 'bW')
    let end_line = line(".")
    let end_offset = 2
    let closing_offset = 0
  endif

  let curPos = getpos('.')
  call setpos('.', [curPos[0], start_line, 0, 0])
  let story_numbers = []

  while (line('.') <= end_line)
    let story_numbers += [substitute(getline("."), re, '\1', '')]
    call setpos('.', [curPos[0], (line('.')+1), 0, 0])
  endwhile

  call append((line(".")-1), [ join(story_numbers, ', ') ] )
  call search('^$', 'W')
  let end_line = (line(".") - 1)
  call setpos('.', [curPos[0], end_line, 0, 0])
endfunction

" vmap <buffer> qpt :normal ''\:call PtAddPoints()<CR>
vmap <buffer> qpt :call PtAddPoints('v')<CR>
nmap <buffer> qpt :call PtAddPoints('n')<CR>
vmap <buffer> qpn :call PtListStoryNumbers('v')<CR>
nmap <buffer> qpn :call PtListStoryNumbers('n')<CR>

nmap <buffer> qpf :call ReformatPtStoriesFor('DV')<CR>

