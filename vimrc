" Vundle
set nocompatible
filetype off

""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle - the vim plugin bundler     "
""""""""""""""""""""""""""""""""""""""""""""""""""
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1
    let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Plugin 'gmarik/Vundle.vim'
"Add your bundles here

" Theme
Plugin 'tomasr/molokai'

" Command Tool
Plugin 'mileszs/ack.vim'
Plugin 'vim-scripts/cscope_plus.vim'


" Useful Tool
Plugin 'scrooloose/nerdtree'
Plugin 'fidian/hexmode'
Plugin 'kien/ctrlp.vim'


" Syntax
Plugin 'Inndy/nginx-vim-syntax'


" Powerful Editing
Plugin 'vim-scripts/Auto-Pairs'
Plugin 'junegunn/vim-easy-align'
Plugin 'tpope/vim-surround'
Plugin 'ervandew/supertab'


" Front-End
Plugin 'mattn/emmet-vim'

Plugin 'othree/html5.vim'
Plugin 'othree/html5-syntax.vim'

Plugin 'css3-syntax-plus'
Plugin 'gorodinskiy/vim-coloresque'

Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'


" For PHP
Plugin 'vim-scripts/php.vim'
Plugin 'stephpy/vim-php-cs-fixer'
Plugin 'xsbeats/vim-blade'

" For Python
"Plugin 'davidhalter/jedi-vim'

if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle - the vim plugin bundler end "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Theme
let g:rehash256 = 1
color molokai

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
set tabpagemax=100
set tabstop=4

syntax on
filetype plugin indent on

autocmd FileType python setlocal et sta sw=4 sts=4 cc=80 completeopt-=preview
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
nmap <c-j> :call emmet#moveNextPrev(0)<CR>
imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
nmap <c-k> :call emmet#moveNextPrev(1)<CR>
imap <c-k> <esc>:call emmet#moveNextPrev(1)<CR>
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

" Use hjkl :)
nnoremap <left> :echo "Try to use `h`"<CR><left>
nnoremap <right> :echo "Try to use `l`"<CR><right>
nnoremap <up> :echo "Try to use `k`"<CR><up>
nnoremap <down> :echo "Try to use `j`"<CR><down>

" Run files
autocmd filetype ruby nnoremap <F5> :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype javascript nnoremap <F5> :w <bar> exec '!nodejs '.shellescape('%') <CR>
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

" CtrlP
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$',
	\ }

"color ron
"blue       delek      evening    murphy     ron        torte
"darkblue   desert     koehler    pablo      shine      zellner
"default    elflord    morning    peachpuff  slate

" Fix backspace in iTerm2
set backspace=indent,eol,start

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
