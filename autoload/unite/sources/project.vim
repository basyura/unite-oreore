
if !exists('g:unite_project_root')
  let g:unite_project_root = '/'
endif
if !exists('g:unite_project_sub_dirs')
  let g:unite_project_sub_dirs = []
endif

let s:unite_source = {}
let s:unite_source.name = 'project'
let s:unite_source.default_action = {'cdable' : 'cd'}
let s:unite_source.action_table = {'src' : 'cd'}

function! s:unite_source.gather_candidates(args, context)
  let list = map(split(globpath(g:unite_project_root ,'*'),'\n') ,
        \ '[fnamemodify(v:val , ":t") , v:val]')
  return map(list, '{
        \ "abbr"   : v:val[0],
        \ "word"   : v:val[1],
        \ "source" : "project",
        \ "kind"   : "cdable",
        \ "action__directory": v:val[1],
        \ }')
endfunction

" action table
let s:action_table = {}
" cd src
let s:action_table.src = {'description' : 'cd src'}
function! s:action_table.src.func(candidate)
  execute 'cd ' . a:candidate.word . '/src'
endfunction
" cd ContextRoot
let s:action_table.context_root = {'description' : 'cd ContextRoot'}
function! s:action_table.context_root.func(candidate)
  execute 'cd ' . a:candidate.word . '/ContextRoot'
endfunction
" cd scripts
let s:action_table.scripts = {'description' : 'cd scripts'}
function! s:action_table.scripts.func(candidate)
  execute 'cd ' . a:candidate.word . '/ContextRoot/scripts'
endfunction
" cd jsp
let s:action_table.jsp = {'description' : 'cd jsp'}
function! s:action_table.jsp.func(candidate)
  execute 'cd ' . a:candidate.word . '/ContextRoot/jsp'
endfunction

" sub dir
for s:v in g:unite_project_sub_dirs
  let s:action_table[s:v['action']] = {'description' : s:v['description']}
  function! s:action_table[s:v['action']].func(candidate, ...) dict
    if a:0 != 0
      let self.path = a:1
      return self.path
    else
      execute 'cd '. a:candidate.word . '/' . self.path
    endif
  endfunction
  call s:action_table[s:v['action']].func(0, s:v['path'])
endfor

let s:unite_source.action_table.cdable = s:action_table

" source
function! unite#sources#project#define()
  return s:unite_source
endfunction
