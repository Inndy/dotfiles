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
    silent !git clone https://github.com/Shougo/neobundle.vim --depth 1 ~/.vim/bundle/neobundle.vim
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

NeoBundle 'editorconfig/editorconfig-vim'

" Theme
NeoBundle 'tomasr/molokai'


" UI
"NeoBundle 'bling/vim-airline'
NeoBundle 'airblade/vim-gitgutter'

" Make Vim Powerful
NeoBundle 'tpope/vim-repeat'
NeoBundle 'embear/vim-localvimrc'
NeoBundle 'triglav/vim-visual-increment'


" Command Tool
NeoBundle 'mileszs/ack.vim'
"NeoBundle 'vim-scripts/cscope_plus.vim'


" Useful Tool
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'fidian/hexmode'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/gist-vim', {'depends': 'mattn/webapi-vim'}
NeoBundle "majutsushi/tagbar"


" Syntax
"NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'YAJS--Yet-Another-JavaScript-Syntax'
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'hdima/python-syntax'
"NeoBundle 'mxw/vim-jsx'


" Powerful Editing
NeoBundle 'vim-scripts/Auto-Pairs'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'tpope/vim-surround'
NeoBundle 'ervandew/supertab'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'python_match.vim'
NeoBundle 'terryma/vim-multiple-cursors'


" Front-End
NeoBundle 'mattn/emmet-vim'

NeoBundle 'othree/html5.vim'
NeoBundle 'othree/html5-syntax.vim'

"NeoBundle 'slim-template/vim-slim'

"NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'gorodinskiy/vim-coloresque'

NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/yajs.vim'


" For PHP
NeoBundle 'StanAngeloff/php.vim'
NeoBundle 'stephpy/vim-php-cs-fixer'
NeoBundle 'xsbeats/vim-blade'

" For Python
"NeoBundle 'davidhalter/jedi-vim'

" For Ruby and Rails
"NeoBundle 'vim-ruby/vim-ruby'

" For CoffeeScript
NeoBundle 'kchmck/vim-coffee-script'


let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

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

set autoindent                   " 自動縮排
set backspace=indent,eol,start   " 統一 backsapce 功能
set colorcolumn=100              " 換行提示線
set cursorline                   " 目前游標所在這行反白
set directory=~/.vim/swapfiles// " 設定 swapfile 目錄
set expandtab                    " 把 tab 展開成空白
set hlsearch                     " 顏色標記被搜尋的文字
set ignorecase                   " 搜尋忽略大小寫
set incsearch                    " 往後搜尋
set nobackup                     " 關閉備份檔案
set noswapfile                   " 不使用 swapfile
set nowritebackup                " 關閉備份檔案
set number                       " 顯示行數
set ruler                        " 游標位置資訊
set scrolloff=3                  " 游標距離上下 N 行開始捲動螢幕
set shiftwidth=4                 " tab 寬度
set showcmd                      " 顯示命令按鍵
set smartcase                    " 搜尋時自動判斷是否區分大小寫
set smartindent                  " 自動縮排
set t_Co=256                     " 啟用256色彩空間
set tabpagemax=100               " 一次最多可以開多少tab
set tabstop=4                    " tab寬度
set timeoutlen=300               " escape delay
set wildmenu                     " 自動補完選單

syntax on
filetype plugin indent on

" _____ _ _     _____                   ____      _       _           _
"|  ___(_) | __|_   _|   _ _ __   ___  |  _ \ ___| | __ _| |_ ___  __| |
"| |_  | | |/ _ \| || | | | '_ \ / _ \ | |_) / _ \ |/ _` | __/ _ \/ _` |
"|  _| | | |  __/| || |_| | |_) |  __/ |  _ <  __/ | (_| | ||  __/ (_| |
"|_|   |_|_|\___||_| \__, | .__/ \___| |_| \_\___|_|\__,_|\__\___|\__,_|
"                    |___/|_|

autocmd FileType python setlocal et sta sw=4 sts=4 cc=80 completeopt-=preview
autocmd FileType html setlocal et sw=2 sts=2

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
let g:NERDTreeWinSize=22
let NERDTreeIgnore=['__pycache__', '\.o$', '\.pyc$', '\~$', 'node_modules']

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabedit 

" emmet
imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
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
map <leader>p "*p
map <leader>y "*y

" _____                     _   _
"| ____|_  _____  ___ _   _| |_(_) ___  _ __
"|  _| \ \/ / _ \/ __| | | | __| |/ _ \| '_ \
"| |___ >  <  __/ (__| |_| | |_| | (_) | | | |
"|_____/_/\_\___|\___|\__,_|\__|_|\___/|_| |_|

autocmd filetype c          nnoremap <leader>r :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cs         nnoremap <leader>r :w <bar> exec '!mcs '.shellescape('%').' && mono '.shellescape('%:r').'.exe'<CR>
autocmd filetype cpp        nnoremap <leader>r :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd filetype php        nnoremap <leader>r :w <bar> exec '!php -f '.shellescape('%') <CR>
autocmd filetype java       nnoremap <leader>r :w <bar> exec '!javac '.shellescape('%').'&&java '.shellescape('%:r') <CR>
autocmd filetype lisp       nnoremap <leader>r :w <bar> exec '!clisp '.shellescape('%') <CR>
autocmd filetype perl       nnoremap <leader>r :w <bar> exec '!perl '.shellescape('%') <CR>
autocmd filetype ruby       nnoremap <leader>r :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype shell      nnoremap <leader>r :w <bar> exec '!bash '.shellescape('%') <CR>
autocmd filetype python     nnoremap <leader>r :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype javascript nnoremap <leader>r :w <bar> exec '!nodejs '.shellescape('%') <CR>

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
	\ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules)$',
	\ 'file': '\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$',
	\ }

" python-syntax
let python_highlight_all = 1

" vim-css3-syntax
augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END

" vim-surround
let g:surround_45="<% \r %>"   " -
let g:surround_61="<%= \r %>"  " =
let g:surround_33="<!-- \r -->" "!
let g:surround_42="/* \r */" "*

" localvimrc
let g:localvimrc_persistent=1

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

if has("gui_macvim") || has("gui_vimr")
   set guifont=Menlo:h14
endif
