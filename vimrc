" _                   _             _  __
"| |    ___  __ _  __| | ___ _ __  | |/ /___ _   _
"| |   / _ \/ _` |/ _` |/ _ \ '__| | ' // _ \ | | |
"| |__|  __/ (_| | (_| |  __/ |    | . \  __/ |_| |
"|_____\___|\__,_|\__,_|\___|_|    |_|\_\___|\__, |
"                                            |___/

let mapleader=" "

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
let iCanHazNeoBundle=1
let NeoBundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(NeoBundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'Shougo/unite.vim'

" Theme
NeoBundle 'tomasr/molokai'


" UI
"NeoBundle 'bling/vim-airline'
NeoBundle 'airblade/vim-gitgutter'

" Make Vim Powerful
NeoBundle 'tpope/vim-repeat'


" Command Tool
NeoBundle 'mileszs/ack.vim'
NeoBundle 'vim-scripts/cscope_plus.vim'


" Useful Tool
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'fidian/hexmode'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/gist-vim', {'depends': 'mattn/webapi-vim'}
NeoBundle "majutsushi/tagbar"


" Syntax
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'Inndy/nginx-vim-syntax'
NeoBundle 'hdima/python-syntax'


" Powerful Editing
NeoBundle 'vim-scripts/Auto-Pairs'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'tpope/vim-surround'
NeoBundle 'ervandew/supertab'
NeoBundle 'edsono/vim-matchit'


" Front-End
NeoBundle 'mattn/emmet-vim'

NeoBundle 'othree/html5.vim'
NeoBundle 'othree/html5-syntax.vim'

NeoBundle 'css3-syntax-plus'
NeoBundle 'gorodinskiy/vim-coloresque'

NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/yajs.vim'


" For PHP
NeoBundle 'vim-scripts/php.vim'
NeoBundle 'stephpy/vim-php-cs-fixer'
NeoBundle 'xsbeats/vim-blade'

" For Python
"NeoBundle 'davidhalter/jedi-vim'

" For CoffeeScript
NeoBundle 'kchmck/vim-coffee-script'

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
set directory=~/.vim/swapfiles//
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
set smartcase
set smartindent
set t_Co=256
set tabpagemax=100
set tabstop=4
set timeoutlen=300

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

" tagbar
nmap <F8> :TagbarToggle<CR>

" NERDTree
inoremap <F10> <ESC>:NERDTreeTabsToggle<CR>
nnoremap <silent> <F10> :NERDTreeTabsToggle<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabedit 

" emmet
nmap <c-j> :call emmet#moveNextPrev(0)<CR>
imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
nmap <c-k> :call emmet#moveNextPrev(1)<CR>
imap <c-k> <esc>:call emmet#moveNextPrev(1)<CR>

" gitgutter
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterRevertHunk
nmap <Leader>hv <Plug>GitGutterPreviewHunk

" move in panels
nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

" evil shift!
cab Q q
cab Qa qa
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

autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd filetype cs nnoremap <F5> :w <bar> exec '!mcs '.shellescape('%').' && mono '.shellescape('%:r').'.exe'<CR>
autocmd filetype java nnoremap <F5> :w <bar> exec '!javac '.shellescape('%').'&&java '.shellescape('%:r') <CR>
autocmd filetype javascript nnoremap <F5> :w <bar> exec '!nodejs '.shellescape('%') <CR>
autocmd filetype lisp nnoremap <F5> :w <bar> exec '!clisp '.shellescape('%') <CR>
autocmd filetype php nnoremap <F5> :w <bar> exec '!php -f '.shellescape('%') <CR>
autocmd filetype python nnoremap <F5> :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype ruby nnoremap <F5> :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype shell nnoremap <F5> :w <bar> exec '!bash '.shellescape('%') <CR>

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

" python-syntax
let python_highlight_all = 1

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
