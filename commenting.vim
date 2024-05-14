"" execute "0read " . fnameescape("~/scripts/comment-style-types.txt")

" let s:path = expand('<sfile>:p:h')

" let s:commentsDictionary = {}

" let s:lines = readfile(s:path . '/comment-style-types.txt')
" for s:line in s:lines
"   let s:type = substitute(s:line, '^\([^=]\+\).*', '\1', "")
"   let s:pattern = substitute(s:line, '^\([^=]\+\)=\(.*\)', '\2', "")
"   let s:commentsDictionary[s:type] = s:pattern
" endfor

" function! SetCommentStyle(type)
"   setlocal commentstring=s:commentsDictionary[a:type]
" endfunction
