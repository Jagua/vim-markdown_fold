let s:save_cpo = &cpo
set cpo&vim


"
"
"


function! markdown_fold#expr() abort
  return markdown_fold#foldlevel(v:lnum)
endfunction


function! markdown_fold#foldlevel(lnum) abort
  let group_names = map(synstack(a:lnum, 1), 'synIDattr(v:val, "name")')
  let group_name = get(group_names, 0, '')
  let level = matchstr(group_name, '^\C\%(htmlH\|markdownH\)\zs[[:digit:]]\+\ze')
  if empty(level)
    return '='
  endif
  let line = getline(a:lnum)
  if line =~? '^=\+' && level ==? '1' || line =~? '^-\+' &&  level ==? '2'
    return '='
  endif
  return '>' . level
endfunction


"
"
"


function! markdown_fold#qfexpr() abort
  let l:Padding = {lnum -> repeat('.', float2nr(log10(line('$'))) - float2nr(log10(lnum)) + 1)}
  return map(markdown_fold#headings(),
        \ 'printf("%s:%d:%s%s", bufname("%"), v:val.lnum, l:Padding(v:val.lnum), v:val.word)')
endfunction


function! markdown_fold#headings() abort
  let headings = []
  for lnum in range(1, line('$'))
    let line = getline(lnum)
    if line !~? '^\%(#\+\|=\+\|-\+\)'
      continue
    endif
    if line =~? '^=\+' && lnum > 1 || line =~? '^-\+' && lnum > 1
      let lnum -= 1
    endif
    let group_name = synIDattr(synID(lnum, 1, 1), 'name')
    if group_name =~? '^\C\%(markdownHeadingDelimiter\|\%(htmlH\|markdownH\)[[:digit:]]\)'
      call add(headings, {'lnum' : lnum, 'word' : getline(lnum)})
    endif
  endfor
  return headings
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
