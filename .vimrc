" ** to begin **
syntax on
set nocompatible              " be iMproved, required
filetype off                  " required

" ** pluggins **
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'joonty/vim-phpqa.git'
Plugin 'StanAngeloff/php.vim.git'
Plugin 'SirVer/ultisnips'
Plugin 'Sigafoos/vim-snippets' " my fork

" ** plugin settings **
" vim-phpqa
" PHP Code Sniffer binary (default = "phpcs")
let g:phpqa_codesniffer_cmd='sniff'
" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0
" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 1
" Show code coverage on load (default = 0)
let g:phpqa_codecoverage_autorun = 0
" better highlighting in docblocks
function! PhpSyntaxOverride()
	hi! def link phpDocTags  phpDefine
	hi! def link phpDocParam phpType
endfunction
augroup phpSyntaxOverride
	autocmd!
	autocmd FileType php call PhpSyntaxOverride()
augroup END

" UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ** other settings I like **
" ** I should probably sort this more? **
set autoindent
set cindent
set smartindent
set number
set hlsearch
set incsearch
set so=7
set clipboard=unnamed
set cursorline
set noswapfile " potentially bad news bears?
set tabstop=4
highlight CursorLine cterm=NONE ctermbg=None ctermfg=None
highlight CursorLineNr ctermbg=23
nnoremap <leader>p :set paste!<return>

set nolist
" stolen from jbaker
highlight RedundantWhitespace ctermbg=darkred guibg=darkred
match RedundantWhitespace /\s\+$/

" ** mappings and such **
let mapleader=","
nnoremap <esc> :noh<return>
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
