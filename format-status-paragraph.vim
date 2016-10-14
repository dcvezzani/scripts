function! FormatStatusParagraph(...)

  " ^[   - ensure normal mode; hit escape key
  " `<   - go to the beginning of the last selection
  " i    - enter insert mode and add a space
  " ^[`< - exit insert mode and go to the beginning of the last selection
  "
  " /[a-zA-Z0-9]^M - search for the first alpha-numeric character
  "
  " v    - enter select mode
  " $    - select everything from current position to the end of the line
  " h    - 'un-highlight' one character to the left
  " "yy  - store the selected text in the 'y' register
  let @z = '`<i `</[a-zA-Z0-9]v$h"yy'
  normal @z

  "let @z = 'gv"wy'
  "normal @z

  let @z = 'o"ypV:s/\<./\u&/g`<v$h"wygv:s/[^a-zA-Z0-9]\+/-/g'
  normal @z

  "* [an api error for reports that have never worked?](Api-Error-for-Reports-That-Have-Never-Worked)

  let @z = '`<v$h"yyddk'
  normal @z

  let @z = '^hx'
  normal @z

  let $WFN = strftime("(%a, %d %b %Y)")."* [".@w."](".@y.")"

  " include content and link to github wiki page
  " use `gx` when cursor on url to open in browser
  let cleanWfn = split($WFN, '') + ['https://github.com/crystalcommerce/core/wiki/'.@y.' /_edit', 'https://github.com/crystalcommerce/core/wiki/dave-v-authored-documents/_edit' ]
  call append(".", cleanWfn)
  call cursor(line('.') + len(cleanWfn), 0)

  echo $WFN
endfunction
:command! -range WFN :call WikiFileName() | :r!echo "$WFN" | pbcopy


