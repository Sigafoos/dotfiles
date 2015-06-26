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
Plugin 'tomtom/tlib_vim' " for bootstrap
Plugin 'MarcWeber/vim-addon-mw-utils' " ditto
Plugin 'Sigafoos/bootstrap-snippets' " my fork
Plugin 'Sigafoos/php.vim-1' " custom syntax stuff
Plugin 'bling/vim-airline'
Plugin 'edkolev/promptline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'joonty/vdebug'
Plugin 'tpope/vim-abolish.git'
Plugin 'tpope/vim-repeat'
Plugin 'svermeulen/vim-easyclip'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

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

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme='murmur'

" promptline
let g:promptline_theme = 'airline'
let g:promptline_preset = {
	\'a' : [ promptline#slices#host() ],
	\'b' : [ promptline#slices#cwd() ],
	\'x' : [ promptline#slices#vcs_branch(), promptline#slices#git_status() ],
	\'warn' : [ promptline#slices#last_exit_code() ]
	\}

" vdebug
let g:vdebug_options = {'port' : '9001'}
let g:vdebug_keymap = {
	\    'run' : '<leader>5',
	\    'run_to_cursor' : '<leader>1',
	\    'step_over' : '<leader>2',
	\    'step_into' : '<leader>3',
	\    'step_out' : '<leader>4',
	\    'close' : '<leader>6',
	\    'detach' : '<leader>7',
	\    'set_breakpoint' : '<leader>10',
	\    'get_context' : '<leader>11',
	\    'eval_under_cursor' : '<leader>12',
	\    'eval_visual' : '<Leader>e',
	\}

" easyclip
let g:EasyClipAutoFormat = 1
let g:EasyClipShareYanks = 1

" abolish
":command S Subvert

" any machine-only Vundle stuff to add?
if filereadable(glob("~/.vundle.local"))
	source ~/.vundle.local
endif

" ** other settings I like **
" ** I should probably sort this more? **
set autoindent
set number
set hlsearch
set incsearch
set so=7
set clipboard=unnamed
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
"
" any machine-only vimrc stuff to add?
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif
