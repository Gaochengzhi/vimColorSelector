" File              : colortheme.vim
" License           : The MIT License (MIT)
" Author            : Gao Chengzhi <2673730435@qq.com>
" Date              : 06.06.2022
" Last Modified Date: 06.06.2022
" Last Modified By  : Gao Chengzhi <2673730435@qq.com>
" Copyright (c) 2022 Gao Chengzhi <2673730435@qq.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.



if exists('g:autoloaded_colortheme') || &cp
  finish
endif 
 
let g:autoloaded_colortheme = 1

function s:GetColorList(schemeList) abort
   let l:colorList = []
   for l:myCol in split(a:schemeList, '\n')
      if l:myCol =~ '\.vim'
         let l:tmp = split(l:myCol,'/')
         let l:myColName = substitute(l:tmp[-1], '\.vim', '', '')
         call add(l:colorList,l:myColName)
      endif
   endfor
   return l:colorList
endfunction


function colortheme#SaveColorThemeChange(colorName) abort
    quit
    echo "Changed!".a:colorName
    "TODO save the result into a config file
    nunmap <cr>

endfunction

"-----------------------------------------------------------------------------
" Public API
"-----------------------------------------------------------------------------    
function ColorTheme() abort
    
    let l:schemeList = "\n".globpath(&rtp, "colors/*.vim")."\n"
    let s:colorList = s:GetColorList(l:schemeList) 
    call s:CreatNewWindow(s:colorList)
    augroup DetectCursor 
            autocmd!
            autocmd CursorMoved * :let colorName =  s:SelectThemeUnderCursor()
            autocmd QuitPre * call s:CloseWindow()
    augroup end
    nnoremap <cr> :call colortheme#SaveColorThemeChange(colorName)<cr>
endfunction

"-----------------------------------------------------------------------------
" Private API
"-----------------------------------------------------------------------------    


function s:SelectThemeUnderCursor() abort
    let l:wordUnderCursor = expand("<cword>")
    exec "colorscheme" l:wordUnderCursor
    return l:wordUnderCursor
endfunction

function s:CloseWindow() abort
   autocmd! DetectCursor 
   quit
endfunction


function s:CreatNewWindow(colorList) abort
    new theme_select 
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal bufhidden=delete
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal nocursorline
    setlocal nobuflisted
    setlocal modifiable
    call append(0, a:colorList)
    setlocal readonly
    exec "normal gg"
endfunction


command! Colortheme call ColorTheme()
