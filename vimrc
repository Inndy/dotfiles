" Theme
let g:rehash256 = 1
color molokai
syntax on

" Vundle
set nocompatible
filetype off

""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle - the vim plugin bundler     "
""""""""""""""""""""""""""""""""""""""""""""""""""
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle --depth 1
    let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
"Add your bundles here
Plugin 'mileszs/ack.vim'
Plugin 'vim-scripts/Auto-Pairs'
Plugin 'vim-scripts/HTML5-Syntax-File'
Plugin 'vim-scripts/cscope_plus.vim'
Plugin 'vim-scripts/html5.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/php.vim'
Plugin 'mattn/emmet-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'junegunn/vim-easy-align'

if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle - the vim plugin bundler end "
""""""""""""""""""""""""""""""""""""""""""""""""""


" Settings
set autoindent
set colorcolumn=80
set cursorline
set expandtab
set hlsearch
set ignorecase
set incsearch
set number
set ruler
set shiftwidth=4
set showcmd
set smartindent
set t_Co=256
set tabstop=4


"source ~/.vim/theme_jellybeans.vim

autocmd FileType python setlocal et sta sw=4 sts=4
"autocmd FileType html setlocal et sw=2 sts=2
"autocmd FileType php setlocal et sw=2 sts=2
"autocmd FileType js setlocal et sw=2 sts=2
"autocmd FileType jade setlocal et sw=2 sts=2

" Key Mapping
nnoremap <c-l> :noh<CR>
inoremap <F10> <ESC>:NERDTreeToggle<CR>
nnoremap <silent> <F10> :NERDTreeToggle<CR>
nmap <Tab> gt
nmap <S-Tab> gT
map <S-T> :tabedit 

cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq

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

"color ron
"blue       delek      evening    murphy     ron        torte
"darkblue   desert     koehler    pablo      shine      zellner
"default    elflord    morning    peachpuff  slate

" Fix backspace in iTerm2
set backspace=indent,eol,start
