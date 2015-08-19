" :nunmap <C-X>
":nunmap <C-X>x
" :nunmap <C-X>y
" :nunmap <C-X-X>
":nunmap <C-X-Y>

" ¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤
" mark with 'code' tag
function! MarkWithCodeTag(...)
  call SelectToken()
  let @z = '"yy' | normal @z
  let @z = 'gvxi<code>"ypa</code>' | normal @z
endfunction
":command! RECR      :call ReformatExpiredCertificateReport()
":command! XX      :call ReformatExpiredCertificateReport()
nnoremap  <C-X>x  :call MarkWithCodeTag()

" ¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤
" select token that cursor is on
function! XSelectToken(...)
  "let @z = 'jk/\v([^[:space:]]([[:space:]|$])@=)' | normal @z
  let @z = '/\v[^[:space:]]([[:space:][:return:]]|$)mb' | normal @z
  let @z = '/\v(([[:space:]])@<=([^[:space:]])|^([^[:space:]]))Nma' | normal @z
  let @z = '`av`b' | normal @z
endfunction
":command! RECR      :call ReformatExpiredCertificateReport()
":command! XX      :call SelectToken()
"nnoremap  <C-X-Y>  :call SelectToken()

function! SelectToken(...)
  let @z = '/\(\(\s\)\@<=\(\w\|\d\)\|$\)Nma' | normal @z
  let @z = '/\(\w\|\d\)\([^a-zA-Z0-9]*\(\s\|$\)\)\@=mb' | normal @z
  let @z = '`av`b' | normal @z
  " let @z = '/\(\(\s\)\@<=\(\w\|\d\)\|$\)Nv' | normal @z
endfunction


" [^\s]\(\s\)\@=
" \v[^\s](\s)@=

" ¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤
" given two separate lines, the first with the link name
" and the second with the link url, create an anchor tag
" e.g., 
" URL Decoder/Encoder
" http://meyerweb.com/eric/tools/dencoder/
" 
function! CreateLinkFromTwoLines(...)
  let @z = 'jv$h"yykv$h,a"ypjddw' | normal @z
endfunction
":command! XX      :call ReformatExpiredCertificateReport()
"nnoremap  <C-X>x  :call CreateLinkFromTwoLines()


