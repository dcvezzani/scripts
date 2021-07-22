function! DisableMochaTests()
  let origPos = getpos('.')
  let @z = ':%s#it(#xit(#g
  let @z = ':%s#xxit(#it(#g
  call setpos('.', origPos)
endfunction

function! EnableMochaTests()
  let origPos = getpos('.')
  let @z = ':%s#x*it(#it(#g
  call setpos('.', origPos)
endfunction

nmap qit :call DisableMochaTests()<CR>
nmap qiT :call EnableMochaTests()<CR>


