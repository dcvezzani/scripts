" let g:S = 0
function! Sum(number)
    let g:S = g:S + str2float(a:number)
    return a:number
endfunction
