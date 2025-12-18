function! TabFeature(state)
    if a:state == 'on'
        set noexpandtab
        set tabstop=2
        set shiftwidth=2
        set smarttab
    else
        set expandtab
        set tabstop=4
        set shiftwidth=4
    endif
endfunction

" Unmap qto if it exists and map it to call TabFeature with arguments
if mapcheck('qto') != ''
		unmap qto
endif

map qtO :call TabFeature('on')<CR>
map qto :call TabFeature('off')<CR>

