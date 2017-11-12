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
call vundle#end()            " required
filetype plugin indent on    " required









""""""""""""""""""""""""""
"   Settings
""""""""""""""""""""""""""

set incsearch		" interactive search
set nocompatible	" disable vi compatibility
set number			" show line numbers
set backspace=indent,eol,start	" allows BS to delete these characters
set autoindent		" use indentation of the previous line
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
set mouse=a			" enables mouse in all modes
set showtabline=2	" always show tabbar
set tabpagemax=10	" max tabs to show. use :next or :last to navigate to exceeding tabs
set nowrap 			" disable line break

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
" doesnt work propperly
"scriptencoding utf-8
"set listchars=tab:▸\ ,eol:¬
"set list












""""""""""""""""""""""""""
"	Colors
""""""""""""""""""""""""""
highlight ColorColumn ctermbg=darkgray " colum delimiter color
set background=dark	" dark color scheme
set hlsearch		" highlight search results
syntax on			" syntax highlighting






""""""""""""""""""""""""""
"	MISC
""""""""""""""""""""""""""




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
