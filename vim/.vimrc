set nocompatible
set ts=4
set sw=4
set nu
set relativenumber
set incsearch

"""""""""""""""""""vim-plugin"""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'wikitopian/hardmode'
Plug 'Rip-Rip/clang_complete'
Plug 'dgryski/vim-godef'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""' clang_complete""""""""""""""
let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-4.0.so.1'
"""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""hardmode""""""""""""""""""""'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""vim godef"""""""""""""""""""
let g:godef_split=0
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""netrw setting """"""""""""""""
let g:netrw_banner=0

""""""""""""""""custom remap""""""""""""""""
nmap bo :browse oldfiles<CR>
"""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""abbrev"""""""""""""""""""""
iabbrev #b /*************************
iabbrev #e <CR>***********************/
