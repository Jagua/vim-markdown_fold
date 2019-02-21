let s:save_cpo = &cpo
set cpo&vim


if has('folding') && exists('g:markdown_folding')
  setlocal foldexpr=markdown_fold#expr()
  setlocal foldmethod=expr

  let s:undo_ftplugin = 'setlocal foldexpr< foldmethod<'
  if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= ' | ' . s:undo_ftplugin
  else
    let b:undo_ftplugin = s:undo_ftplugin
  endif
  unlet s:undo_ftplugin
endif


let &cpo = s:save_cpo
unlet s:save_cpo
