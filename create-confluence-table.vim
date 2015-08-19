" ¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤º°`°º¤ø¤º°`°º¤ø,¸¸,ø¤
" create confluence table
"
" | name  | description      |
" | one   | one to grow on   |
" | two   | two to grow on   |
" | three | three to grow on |
"
" Position cursor on some row prior to the first pipe (|); 
" you should not be in Visual mode.
"
" TODO: need to parse out first row to determine column headers
"
function! CreateConfluenceTable()

  "increase buffer for command that is typically printed at the bottom of the
  "window to avoid the distasteful "Press ENTER or type command to continue” 
  "prompt in Vim
  "
  :set cmdheight=2

  "1. select the next table block and surround with Confluence <table> shell
  "2. select the table block again
  "3. convert table block into <td><td>...
  "4. remove leading formatting and remove extra new lines
  "
  let @z = '/^|V/\n\n:s/\(\s*|.*|\n\)\+/<table class="confluenceTable">\r  <tbody>\r    <tr>\r      <th class="confluenceTh">name<\/th>\r      <th class="confluenceTh">description<\/th>\r    <\/tr>\r\r\0  <\/tbody>\r<\/table>\r/gy`</^|V/|\n[^|]$:s/^\s*|\s*\(.\+\)\s*|\s*\(.\+\)\s*|.*$/    <tr>\r      <td class="confluenceTd">\1<\/td>\r      <td class="confluenceTd">\2<\/td>\r    <\/tr>\r/g/<\/\?tableVN:s/^ *//ggv:s/\n\n/\r/gOkj' | normal @z

endfunction

"create 3 key stroke shortcut
":TBL
"
:command! TBL      :call CreateConfluenceTable()
":command! XX      :call ReformatExpiredCertificateReport()
"nnoremap  <C-X>x  :call MarkWithCodeTag()



