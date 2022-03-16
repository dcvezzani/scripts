
function! ZipmdExec()
  let zipmd_command = "~/scripts/zipmd.sh"
  execute "!" . zipmd_command . " " . bufname("%")
endfunction

:command! Zipmd :call ZipmdExec()

