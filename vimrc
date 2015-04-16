" _   _            ____                  _ _
"| \ | | ___  ___ | __ ) _   _ _ __   __| | | ___
"|  \| |/ _ \/ _ \|  _ \| | | | '_ \ / _` | |/ _ \
"| |\  |  __/ (_) | |_) | |_| | | | | (_| | |  __/
"|_| \_|\___|\___/|____/ \__,_|_| |_|\__,_|_|\___|
"

set nocompatible " Be iMproved
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" _____ _
"|_   _| |__   ___ _ __ ___   ___
"  | | | '_ \ / _ \ '_ ` _ \ / _ \
"  | | | | | |  __/ | | | | |  __/
"  |_| |_| |_|\___|_| |_| |_|\___|


let g:rehash256 = 1
color molokai

" ____            _         ____             __ _
"| __ )  __ _ ___(_) ___   / ___|___  _ __  / _(_) __ _
"|  _ \ / _` / __| |/ __| | |   / _ \| '_ \| |_| |/ _` |
"| |_) | (_| \__ \ | (__  | |__| (_) | | | |  _| | (_| |
"|____/ \__,_|___/_|\___|  \____\___/|_| |_|_| |_|\__, |
"                                                 |___/

set autoindent
set backspace=indent,eol,start
set colorcolumn=100
set cursorline
set expandtab
set hlsearch
set ignorecase
set incsearch
set nobackup
set nowritebackup
set number
set ruler
set shiftwidth=4
set showcmd
set smartindent
set t_Co=256
set tabpagemax=100
set tabstop=4

syntax on
filetype plugin indent on

" _____ _ _     _____                   ____      _       _           _
"|  ___(_) | __|_   _|   _ _ __   ___  |  _ \ ___| | __ _| |_ ___  __| |
"| |_  | | |/ _ \| || | | | '_ \ / _ \ | |_) / _ \ |/ _` | __/ _ \/ _` |
"|  _| | | |  __/| || |_| | |_) |  __/ |  _ <  __/ | (_| | ||  __/ (_| |
"|_|   |_|_|\___||_| \__, | .__/ \___| |_| \_\___|_|\__,_|\__\___|\__,_|
"                    |___/|_|

autocmd FileType python setlocal et sta sw=4 sts=4 cc=80 completeopt-=preview
autocmd FileType ruby setlocal et sta sw=2 sts=2
autocmd FileType html setlocal et sw=2 sts=2
autocmd FileType css setlocal et sw=2 sts=2
autocmd FileType blade setlocal et sw=2 sts=2

" _  __            __  __                   _
"| |/ /___ _   _  |  \/  | __ _ _ __  _ __ (_)_ __   __ _
"| ' // _ \ | | | | |\/| |/ _` | '_ \| '_ \| | '_ \ / _` |
"| . \  __/ |_| | | |  | | (_| | |_) | |_) | | | | | (_| |
"|_|\_\___|\__, | |_|  |_|\__,_| .__/| .__/|_|_| |_|\__, |
"          |___/               |_|   |_|            |___/

" clear search result
nnoremap <c-l> :noh<CR>
inoremap <c-l> <c-o>:noh<CR>

" NERDTree
inoremap <F10> <ESC>:NERDTreeTabsToggle<CR>
nnoremap <silent> <F10> :NERDTreeTabsToggle<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <ESC>t :tabedit 

" emmet
nmap <c-j> :call emmet#moveNextPrev(0)<CR>
imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
nmap <c-k> :call emmet#moveNextPrev(1)<CR>
imap <c-k> <esc>:call emmet#moveNextPrev(1)<CR>

" move in panels
nmap <ESC>h <c-w>h
nmap <ESC>j <c-w>j
nmap <ESC>k <c-w>k
nmap <ESC>l <c-w>l

" evil shift!
cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

" integration with system clipboard
map ,p "*p
map ,y "*y

" _____                     _   _
"| ____|_  _____  ___ _   _| |_(_) ___  _ __
"|  _| \ \/ / _ \/ __| | | | __| |/ _ \| '_ \
"| |___ >  <  __/ (__| |_| | |_| | (_) | | | |
"|_____/_/\_\___|\___|\__,_|\__|_|\___/|_| |_|

autocmd filetype ruby nnoremap <F5> :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype javascript nnoremap <F5> :w <bar> exec '!nodejs '.shellescape('%') <CR>
autocmd filetype java nnoremap <F5> :w <bar> exec '!javac '.shellescape('%').'&&java '.shellescape('%:r') <CR>
autocmd filetype lisp nnoremap <F5> :w <bar> exec '!clisp '.shellescape('%') <CR>
autocmd filetype shell nnoremap <F5> :w <bar> exec '!bash '.shellescape('%') <CR>
autocmd filetype php nnoremap <F5> :w <bar> exec '!php -f '.shellescape('%') <CR>
autocmd filetype python nnoremap <F5> :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>

" ____  _             _              ____             __ _
"|  _ \| |_   _  __ _(_)_ __  ___   / ___|___  _ __  / _(_) __ _
"| |_) | | | | |/ _` | | '_ \/ __| | |   / _ \| '_ \| |_| |/ _` |
"|  __/| | |_| | (_| | | | | \__ \ | |__| (_) | | | |  _| | (_| |
"|_|   |_|\__,_|\__, |_|_| |_|___/  \____\___/|_| |_|_| |_|\__, |
"               |___/                                      |___/

" Ctags
let g:ctags_statusline = 1

" Emmet
let g:user_emmet_expandabbr_key = '<c-e>'

" CtrlP
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$',
	\ }

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
