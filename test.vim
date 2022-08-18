let g:re_standup_bullet = "^[-\\*] \\(\\[[ x]\\] \\+\\)*[◐◑● ]*\\(.*\\)"

function! MdRemoveBullet()
  let line = substitute(getline("."), g:re_standup_bullet, "\\2", "")
  call setline(line("."), line)
endfunction

function! MdReplaceBulletYesterday()
  let line = substitute(getline("."), g:re_standup_bullet, "\\2", "")
  call setline(line("."), '- ◐ ' . line)
endfunction

function! MdReplaceBulletToday()
  let line = substitute(getline("."), g:re_standup_bullet, "\\2", "")
  call setline(line("."), '- ◑ ' . line)
endfunction

function! MdReplaceBulletYesterdayAndToday()
  let line = substitute(getline("."), g:re_standup_bullet, "\\2", "")
  call setline(line("."), '- ● ' . line)
endfunction
