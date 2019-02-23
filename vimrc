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

if empty(glob('~/.vim/autoload/plug.vim')) && empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

set nocompatible " Be iMproved
call plug#begin('~/.vim/plugged')
"Plug 'Shougo/vimproc.vim', {'do' : 'make'}

Plug 'tomlion/vim-solidity'

Plug 'tomasr/molokai'

" Make Vim Powerful
Plug 'vim-scripts/Auto-Pairs'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'triglav/vim-visual-increment'
Plug 'vim-scripts/Buffergator'
Plug 'vim-scripts/matchit.zip'

"Plug 'Shougo/neocomplete'


" Syntax
Plug 'chr4/nginx.vim'
Plug 'stanangeloff/php.vim'
Plug 'hdima/python-syntax'
Plug 'keith/swift.vim'

" Cyber Security
Plug 'PProvost/vim-ps1' "ps1
Plug 's3rvac/vim-syntax-yara'


" only load these web front-end related plugins when we need them
if filereadable(expand('~/.frontend.vimenv'))

" syntax
Plug 'othree/html5.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
"Plug 'isRuslan/vim-es6'
"Plug 'pangloss/vim-javascript'
"Plug 'othree/yajs.vim'
Plug 'posva/vim-vue'
Plug 'slim-template/vim-slim'
Plug 'digitaltoad/vim-pug'

" other
Plug 'mattn/emmet-vim'

endif

" Command Tool
Plug 'mileszs/ack.vim'


" Misc
Plug 'mattn/webapi-vim' " dependency for gist-vim
Plug 'mattn/gist-vim'
Plug 'editorconfig/editorconfig-vim'

let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

call plug#end()
filetype plugin indent on

" _____ _
"|_   _| |__   ___ _ __ ___   ___
"  | | | '_ \ / _ \ '_ ` _ \ / _ \
"  | | | | | |  __/ | | | | |  __/
"  |_| |_| |_|\___|_| |_| |_|\___|


let g:rehash256 = 1
if !empty(glob('~/.vim/plugged/molokai/colors/molokai.vim'))
	color molokai
endif

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
set fileencodings=utf-8,default,big5,ucs-bom,latin1
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

autocmd FileType python setlocal et   sw=4 sts=4 cc=80
autocmd FileType html   setlocal et   sw=2 sts=2
autocmd FileType ruby   setlocal noet sw=2 sts=2
autocmd FileType php    setlocal et

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
let NERDTreeIgnore=['__pycache__', '\.o$', '\.pyc$', '\~$', 'node_modules', '\.dSYM$', '\.class$']

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabedit 

" gitgutter
nmap <Leader>ha :GitGutterStageHunk<CR>
nmap <Leader>hu :GitGutterRevertHunk<CR>
nmap <Leader>hv :GitGutterPreviewHunk<CR>

" move in panels
nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

" integration with system clipboard
map <leader>p "*p
map <leader>y "*y

" _____                     _   _
"| ____|_  _____  ___ _   _| |_(_) ___  _ __
"|  _| \ \/ / _ \/ __| | | | __| |/ _ \| '_ \
"| |___ >  <  __/ (__| |_| | |_| | (_) | | | |
"|_____/_/\_\___|\___|\__,_|\__|_|\___/|_| |_|

autocmd filetype c          nnoremap <leader>r :w <bar> exec '!gcc '.shellescape('%').' -std=c99 -O2 && ./a.out'<CR>
autocmd filetype cs         nnoremap <leader>r :w <bar> exec '!mcs '.shellescape('%').' && mono '.shellescape('%:r').'.exe'<CR>
autocmd filetype cpp        nnoremap <leader>r :w <bar> exec '!g++ '.shellescape('%').' -std=c++17 -O2 && ./a.out'<CR>
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

"source ~/.vim/neocomplete.config.vim

" ack.vim
if executable('ag')
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

if has("gui_macvim") || has("gui_vimr")
   set guifont=Menlo:h14
endif
