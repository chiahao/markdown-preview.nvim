" init preview key action
function! mkdp#autocmd#init() abort
  execute 'augroup MKDP_REFRESH_INIT' . bufnr('%')
    autocmd!
    " refresh autocmd
    if g:mkdp_refresh_slow
      autocmd CursorHold,BufWrite,InsertLeave <buffer> call mkdp#rpc#preview_refresh()
    elseif g:mkdp_disable_cursor_hold_refresh
      autocmd CursorMoved,CursorMovedI,BufWrite,InsertLeave <buffer> call mkdp#rpc#preview_refresh()
    else
      autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI <buffer> call mkdp#rpc#preview_refresh()
    endif
    " autoclose autocmd
    if g:mkdp_auto_close
      autocmd BufHidden,BufUnload,BufDelete <buffer> call mkdp#rpc#preview_close_bufnr(expand('<abuf>'))
    endif
  augroup END

  augroup MKDP_SERVER_CLOSE
    autocmd!
    " Keep the server shutdown separate from the buffer-local preview autocmds.
    " Buffer cleanup may clear MKDP_REFRESH_INIT{bufnr} before Vim exits, but
    " VimLeave should still close all preview pages and stop the server.
    autocmd VimLeave * call mkdp#rpc#stop_server()
  augroup END
endfunction

function! mkdp#autocmd#clear_buf(...) abort
  let l:bufnr = get(a:, 1, bufnr('%'))
  execute 'autocmd! ' . 'MKDP_REFRESH_INIT' . l:bufnr
endfunction
