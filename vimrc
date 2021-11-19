set nocompatible
filetype plugin on
let $BASH_ENV = "~/.vim_bash_env"
syntax on
colorscheme onehalfdark 
set signcolumn=yes
hi signcolumn NONE 
hi Pmenu ctermfg=WHITE ctermbg=BLACK 
hi Normal ctermbg=NONE
nmap gc :TComment<cr>

set noswapfile
let g:instant_markdown_autostart=0
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
function! s:markdown_preview()
    silent! InstantMarkdownStop
    silent! InstantMarkdownPreview
endfunction
command! MD call s:markdown_preview()

" syntastic stuffs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" random shortcuts and settings
let g:mapleader = " " 
set tabstop=4
set shiftwidth=4
set expandtab
" Linting shortcuts
nmap <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>p <Plug>(coc-diagnostic-prev) 

packloadall
helptags ALL
