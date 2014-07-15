" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Settings
set number
set autoindent
set smartindent
set hlsearch
set tabstop=4
set shiftwidth=4
set ignorecase
set incsearch
set showcmd
set cursorline
set t_Co=256

" Pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

"source ~/.vim/theme_jellybeans.vim

autocmd FileType python setlocal et sta sw=4 sts=4
"autocmd FileType html setlocal et sw=2 sts=2
"autocmd FileType php setlocal et sw=2 sts=2
"autocmd FileType js setlocal et sw=2 sts=2
"autocmd FileType jade setlocal et sw=2 sts=2

" Key Mapping
"nnoremap <silent> <c-x> :w<CR>
"nnoremap <silent> <c-x> :x<CR>
nnoremap <silent> <F3> :noh<CR>
"nnoremap <silent> <F4> :w<CR>
"nnoremap <silent> <F6> :tabedit 
nnoremap <silent> <F10> :NERDTree<CR>
"nnoremap <silent> <F10> :q<CR>
map <c-t>e :tabedit 
map <c-t>n :tabnew<CR>
map t gt
map T gT
"map :tab :tabedit 

map :Q :q

" Run files
autocmd BufRead *.py nmap <F5> :w !python % <CR>
autocmd BufRead *.lisp nmap <F5> :w !clisp % <CR>
autocmd BufRead *.sh nmap <F5> :w !bash % <CR>
autocmd BufRead *.php nmap <F5> :w !php % <CR>

" Ctags
let g:ctags_statusline = 1
"let g:ctags_regenerate = 0

" Emmet
let g:user_emmet_expandabbr_key = '<c-e>'

" Theme
let g:rehash256 = 1
color molokai

"color ron
"blue       delek      evening    murphy     ron        torte
"darkblue   desert     koehler    pablo      shine      zellner
"default    elflord    morning    peachpuff  slate

" Fix backspace in iTerm2
set backspace=indent,eol,start
