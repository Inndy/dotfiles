" _                   _             _  __
"| |    ___  __ _  __| | ___ _ __  | |/ /___ _   _
"| |   / _ \/ _` |/ _` |/ _ \ '__| | ' // _ \ | | |
"| |__|  __/ (_| | (_| |  __/ |    | . \  __/ |_| |
"|_____\___|\__,_|\__,_|\___|_|    |_|\_\___|\__, |
"                                            |___/

let mapleader=" "

"       _                       _
"__   _(_)_ __ ___        _ __ | |_   _  __ _
"\ \ / / | '_ ` _ \ _____| '_ \| | | | |/ _` |
" \ V /| | | | | | |_____| |_) | | |_| | (_| |
"  \_/ |_|_| |_| |_|     | .__/|_|\__,_|\__, |
"                        |_|            |___/

" Auto install vim-plug for lightweight Vim installs.
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	autocmd VimEnter * PlugInstall | source $MYVIMRC
	source ~/.vim/autoload/plug.vim
endif

set nocompatible " Be iMproved
call plug#begin('~/.vim/plugged')

Plug 'tomasr/molokai'
Plug 'ciaranm/securemodelines'
Plug 'scrooloose/nerdtree'
	Plug 'PhilRunninger/nerdtree-buffer-ops'
	Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Syntax
Plug 'chr4/nginx.vim'
Plug 'PProvost/vim-ps1'
Plug 'cespare/vim-toml'
Plug 'mileszs/ack.vim'
Plug 'junegunn/vim-easy-align'
Plug 'editorconfig/editorconfig-vim'

let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif
call plug#end()


" _____ _
"|_   _| |__   ___ _ __ ___   ___
"  | | | '_ \ / _ \ '_ ` _ \ / _ \
"  | | | | | |  __/ | | | | |  __/
"  |_| |_| |_|\___|_| |_| |_|\___|

filetype plugin indent on
syntax on

let g:rehash256 = 1
if !empty(glob('~/.vim/plugged/molokai/colors/molokai.vim'))
	color molokai
endif

set autoindent
set backspace=indent,eol,start
set colorcolumn=100
set cursorline
set fileencodings=utf-8,big5,ucs-bom,latin1
set hlsearch
set ignorecase
set incsearch
set nobackup
set noswapfile
set nowritebackup
set number
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set smartcase
set smartindent
set splitright
set tabpagemax=100
set tabstop=4
set timeoutlen=300
set wildmenu

if has('termguicolors')
	set termguicolors
endif

autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 colorcolumn=80
autocmd FileType html   setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType php    setlocal expandtab

" NERDTree
inoremap <F10> <ESC>:NERDTreeTabsToggle<CR>
nnoremap <silent> <F10> :NERDTreeTabsToggle<CR>
let g:NERDTreeWinSize=22
let NERDTreeIgnore=['__pycache__', '\.o$', '\.pyc$', '\~$', 'node_modules', '\.dSYM$', '\.class$']
" Clear search result.
nnoremap <C-l> :noh<CR>
inoremap <C-l> <C-o>:noh<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <A-]> gt
nmap <A-[> gT


" move in panels
nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

" integration with system clipboard
map <leader>p "*p
map <leader>y "*y

" vim-surround
let g:surround_33="<!-- \r -->" "!
let g:surround_42="/* \r */" "*

" ack.vim
if executable('ag') || executable('ag.exe')
	let g:ackprg = 'ag --vimgrep'
endif

"  ___  _   _
" / _ \| |_| |__   ___ _ __
"| | | | __| '_ \ / _ \ '__|
"| |_| | |_| | | |  __/ |
" \___/ \__|_| |_|\___|_|

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

hi Search ctermfg=16 ctermbg=226

if executable('win32yank.exe')
	let g:clipboard = {
	\   'name': 'win32yank-wsl',
	\   'copy': {
	\      '*': 'win32yank.exe -i --crlf',
	\    },
	\   'paste': {
	\      '*': 'win32yank.exe -o --lf',
	\   },
	\   'cache_enabled': 0,
	\ }
endif
