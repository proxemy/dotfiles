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
set nocompatible	" be iMproved, required
filetype off		" required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" Plugin 'YouCompleteMe'
" Plugin 'powerline/powerline'
" Below is the new powerline plugin which will replace the above once its
" finished

" use :PluginInstall to install listed repos
Plugin 'git://github.com/powerline/powerline'
Plugin 'git://github.com/Valloric/YouCompleteMe'
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
"set foldmethod=syntax	" fold by syntax (only for C langs?)
set foldmethod=indent	" fold by indentation
set nofoldenable	" dont fold by default
set foldcolumn=3	" shows a fold column on the lest (symbols: +. -, |)

set bs=2			" backspacing behaviour. 3 = backspace over indent, eol, start 
set colorcolumn=79	" highlight column 79 to respect line length
set showtabline=2	" always show tabbar
set tabpagemax=10	" max tabs to show. use :next or :last to navigate to exceeding tabs
set nowrap 			" disable line break
"set sidescroll=10	" number of columns to scroll horizontally, good for slow terminals
set sidescrolloff=999	" number of columns to keep on screen borders while horizontally scrolling





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
set listchars=tab:▸\ ,eol:¬
set list " display tab or eol chars












""""""""""""""""""""""""""
"	Colors
""""""""""""""""""""""""""
" only turn on colors if terminal supports it
if &t_Co > 2 || has('gui_rendering')
	highlight ColorColumn ctermbg=darkgray " colum delimiter color
	set background=dark	" dark color scheme
	set hlsearch		" highlight search results
	syntax on			" syntax highlighting
endif






""""""""""""""""""""""""""
"	MISC
""""""""""""""""""""""""""

" enalbe mouse
if has('mouse')
	set mouse=a
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
set clipboard=unnamed

" create a new <leader> key
let mapleader=","	" with 'm','n' below, allows easy tab switches


" easier movement between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
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
  autocmd FileType text setlocal textwidth=78

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
