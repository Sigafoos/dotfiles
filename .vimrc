" ** to begin **
syntax on
set nocompatible              " be iMproved, required
filetype off                  " required

" ** pluggins **
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-abolish.git'
Plugin 'tpope/vim-repeat'
Plugin 'svermeulen/vim-easyclip'

" any machine-only Vundle stuff to add?
if filereadable(glob("~/.vundle.local"))
	source ~/.vundle.local
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ** plugin settings **
" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme='bubblegum'

" easyclip
let g:EasyClipAutoFormat = 1
let g:EasyClipShareYanks = 1

" ** other settings I like **
" ** I should probably sort this more? **
set autoindent
set number
set hlsearch
set incsearch
set so=7
set clipboard=unnamedplus
set cursorline
set noswapfile " potentially bad news bears?
set tabstop=4
set shiftwidth=4
highlight CursorLine cterm=NONE ctermbg=None ctermfg=None
highlight CursorLineNr ctermbg=23
" This doesn't work with tmux, but if you :sp ...?
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
set laststatus=2

set nolist
set list lcs=tab:\|\ 
" stolen from jbaker
highlight RedundantWhitespace ctermbg=darkred guibg=darkred
match RedundantWhitespace /\s\+$/

" ** mappings and such **
let mapleader=","
" otherwise some terminals send the esc command too early?
" see http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour/16027716#16027716
autocmd TermResponse * nnoremap <esc> :noh<return>
nnoremap ; :
nnoremap <leader>; ;
"edit ~/.vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
" source ~/.vimrc
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> <leader>pi :PluginInstall<CR>
nmap <silent> <leader>pc :PluginClean<CR>
" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '
nnoremap <leader>p :set paste!<return>

" any machine-only vimrc stuff to add?
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif
