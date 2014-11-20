" Theme
let g:rehash256 = 1
color molokai

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
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/php.vim'
Plugin 'mattn/emmet-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'junegunn/vim-easy-align'
Plugin 'Inndy/nginx-vim-syntax'
Plugin 'othree/html5.vim'
Plugin 'othree/html5-syntax.vim'
" Yet Another Javascript Syntax
Plugin 'othree/yajs.vim'
Plugin 'tpope/vim-surround'
Plugin 'xsbeats/vim-blade'

Plugin 'fidian/hexmode'

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
set colorcolumn=100
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

syntax on
filetype plugin indent on

"source ~/.vim/theme_jellybeans.vim

autocmd FileType python setlocal et sta sw=4 sts=4 cc=80
autocmd FileType ruby setlocal et sta sw=2 sts=2
autocmd FileType html setlocal et sw=2 sts=2
autocmd FileType blade setlocal et sw=2 sts=2
"autocmd FileType php setlocal et sw=2 sts=2
"autocmd FileType js setlocal et sw=2 sts=2
"autocmd FileType jade setlocal et sw=2 sts=2

" Key Mapping
nnoremap <c-l> :noh<CR>
inoremap <c-l> <c-o>:noh<CR>
inoremap <F10> <ESC>:NERDTreeToggle<CR>
nnoremap <silent> <F10> :NERDTree<CR>
vmap <Enter> <Plug>(EasyAlign)
nmap <Tab> gt
nmap <S-Tab> gT
map <S-T> :tabedit 
nmap <c-n> :call emmet#moveNextPrev(0)<CR>
imap <c-n> <esc>:call emmet#moveNextPrev(0)<CR>
nmap <c-b> :call emmet#moveNextPrev(1)<CR>
imap <c-b> <esc>:call emmet#moveNextPrev(1)<CR>
nmap <ESC>h <c-w>h
nmap <ESC>j <c-w>j
nmap <ESC>k <c-w>k
nmap <ESC>l <c-w>l

cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

map ,p "*p
map ,y "*y

" Run files
autocmd filetype ruby nnoremap <F5> :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype lisp nnoremap <F5> :w <bar> exec '!clisp '.shellescape('%') <CR>
autocmd filetype shell nnoremap <F5> :w <bar> exec '!bash '.shellescape('%') <CR>
autocmd filetype php nnoremap <F5> :w <bar> exec '!php -f '.shellescape('%') <CR>
autocmd filetype python nnoremap <F5> :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>

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

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
