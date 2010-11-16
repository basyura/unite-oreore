" project source for unite.vim
" Version:     0.0.1
" Last Change: 15 Nov 2010
" Author:      basyura <basyrua at gmail.com>
" Licence:     The MIT License {{{
"     Permission is hereby granted, free of charge, to any person obtaining a copy
"     of this software and associated documentation files (the "Software"), to deal
"     in the Software without restriction, including without limitation the rights
"     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"     copies of the Software, and to permit persons to whom the Software is
"     furnished to do so, subject to the following conditions:
"
"     The above copyright notice and this permission notice shall be included in
"     all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
"     THE SOFTWARE.
" }}}

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
        \ "word"   : v:val[0],
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
