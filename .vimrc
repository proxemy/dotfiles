" to show help to the .vimrc file type:
" :help vimrc
" :help vimrc-intro
" :help vimrc_example.vim
" :help auto-settings


""""""""""""""""""""""""""
" Vundle - Plugin Manager
""""""""""""""""""""""""""
"
" install vundle :
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
"
set nocompatible	" be iMproved, required as first command
filetype off		" required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" Below is the new powerline plugin which will replace the above once its
" finished

" use :PluginInstall to install listed repos
Plugin 'git://github.com/powerline/powerline'
Plugin 'git://github.com/Valloric/YouCompleteMe'
Plugin 'git://github.com/tpope/vim-surround'
Plugin 'git://github.com/vim-syntastic/syntastic'
"Plugin 'vim-airline/vim-airline'	" lightweight alterniative to powerline

" All of your Plugins must be added before the following line
call vundle#end()			" required
" filetype plugin indent on	" required, enabled below in 'vimrc_example' section









""""""""""""""""""""""""""
"   Settings
""""""""""""""""""""""""""

set incsearch		" interactive search
set nocompatible	" disable vi compatibility
set number			" show line numbers
set backspace=indent,eol,start	" allows BS to delete these characters
set autoindent		" use indentation of the previous line
set cindent			" use c snytax indentation
set smartindent		" yep, smartindet
set history=200		" command and search history
set undolevels=200	" undo levels
set ruler			" show cursor position in the lower right
"set cursorline		" unterline/show the current cursorline
set showcmd			" show command while typing
" filetype plugin indent on	" recognizing file types, loads plugins (if exit) and detects indentation style
"set spell			" spell checker (en)
"set spl=en			" spell check language
set smd				" show mode (normal, insert, replace, visual) when switching
set verbose=0		" verboselevel to show startup/exit vim processes, default: 11.
set more			" show '--more--' in listings
" set eol				" puts an eol at the last line in file
" set fixeol		" fix missing eol at the end of file
set relativenumber	" relative line numbers
set hidden			" show hidden buffers


"set foldmethod=syntax	" fold by syntax (only for C langs?)
set foldmethod=indent	" fold by indentation
set nofoldenable	" dont fold by default
set foldcolumn=3	" shows a fold column on the lest (symbols: +. -, |)
set fillchars=fold:\ " disable 'fillchars' in 'foldtext' lines
set foldtext=\		" disable foldtext() method
set formatoptions=jl	" Formating option, see :help fo-table for details

set bs=2		" backspacing behaviour. 2 = backspace over indent, eol, start 
set showtabline=2	" always show tabbar
set tabpagemax=10	" max tabs to show. use :next or :last to navigate to exceeding tabs
set nowrap			" disable line break
"set sidescroll=10	" number of columns to scroll horizontally, good for slow terminals
set sidescrolloff=10	" number of columns to keep on screen borders while horizontally scrolling
set scrolloff=3		" number of linse that will be kept while vertical scrolling



" User interface
set wildchar=<TAB>
set wildmenu	" ':' menu with 'wildchar' (TAB)
set wildmode=full

" status line
"set laststatus=2	" always show a status line
"set statusline=
"set statusline+=[%{winnr()}]\         " window number
"set statusline+=[%{fugitive#head()}]\ " current git branch
"set statusline+=%q%f\                 " quickfix label or filename
"set statusline+=%m                    " modified flag
"set statusline+=%=                    " split between left and right sides
"set statusline+=%3l/%3L:%2c           " currentline/totallines:column



" tabs and spaces
set tabstop=4		" tabstop = tabwidth
"set shiftwidth=4	" one foldlevel = 4 chars (tab_size=8 wont fold properly)
"set softtabstop=0
set noexpandtab



" disable backups and swaps, just save one file
set nobackup
set nowritebackup
set noswapfile




" show tabs and eol as chars:
" doesnt work propperly?
scriptencoding utf-8
set listchars=tab:▸\ ,eol:¬,trail:·
set list " display non-printable characters as above






" mark long lines and trialing white spaces as errors
"match ErrorMsg '\%>120v.\+'
"match ErrorMsg '\s\+$'



" use enter/backspace in normal mode to move per paragraph
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {
nnoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
onoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
vnoremap <CR> }





""""""""""""""""""""""""""
"	Colors
""""""""""""""""""""""""""
" only turn on colors if terminal supports it
if &t_Co > 2 || has('gui_rendering')

	" set the color column to show/delimit line length
	set colorcolumn=80
	highlight ColorColumn ctermbg=LightGrey

	" colors
	set background=dark " dark color scheme
	set hlsearch		" highlight search results
	syntax enable			" syntax highlighting without overwriting existing settings

	" custom highlighting
	" with ':highlight', you can see all possible highlight-groups
	hi LineNr term=bold cterm=bold ctermfg=DarkYellow
	hi Comment ctermfg=DarkCyan
	hi clear Error
	hi Error term=underline cterm=underline ctermfg=Red
	hi Folded term=underline cterm=underline ctermfg=DarkGrey ctermbg=DarkGrey
	hi NonText term=bold cterm=bold ctermfg=DarkGrey
	hi SpecialKey term=none cterm=none ctermfg=DarkGrey
	hi clear Search
	hi Search term=reverse cterm=reverse
	" hi CursorLine term=underline cterm=underline guibg=Grey40 ctermbg=DarkGrey
endif




"
" Syntastic options
"
" if exists(syntastic)
let g:ycm_show_diagnostics_ui = 0 " needed because YCM disables all syntastic checkers by default
" let g:syntastic_cpp_checkers = 'gcc'
let g:syntastic_aggregate_errors = 1 " show error from all checkers
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++1z -stdlib=libc++'
let g:syntastic_python_checkers=['flake8', 'python3']
let g:syntastic_python_flake8_args='--ignore W,E203,E303,E128,E124,E731,E265,E722'


" recommended Syntastic options by publisher
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" end: recommended options


""""""""""""""""""""""""""
"	MISC
""""""""""""""""""""""""""

" enalbe mouse fetures
if has('mouse')
	set mouse=a
	set mousefocus
endif


" disable 'python.vim's F#@!%ing space indentation
" let g:python_recommended_style = 0
" au Filetype python set noet
" no success yet ...





"
" C/C++ recommendations from
" http://www.alexeyshmalko.com/2014/using-vim-as-c-cpp-ide/
" set exrc		" vim executes a local .vimrc file for project specific settings
set secure		" limit the autoexec feature from "exrc" for security considerations


" you can enter ":make" to execute make in the current directory.
" this specifies a target directory
set makeprg=make\ -C\ ../build\ -j4

"
" recommendation from
" Vim as a Python IDE - Martin Brochhaus
" https://www.youtube.com/watch?v=YhqsjUUHj6g
"

" better copy and paste
set pastetoggle=<F2>
set clipboard=unnamed " Use the system clipboard

" create a new <leader> key
let mapleader=","	" with 'm','n' below, allows easy tab switches


" easier movement between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
map <Leader>e <esc>:Hexplore<CR>
noremap <Leader>E :qa!<CR> " quit all windows

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" easier moving of selected code block
vnoremap < <gv	" right
vnoremap > >gv	" left

" Automatic relaoding of .vimrc
autocmd! bufwritepost ~/.vimrc source %




" FROM: /usr/share/vim/vim ...
" $VIMRUNTIME/vimrc_example.vim

" An example for a vimrc file.

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=0

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif
