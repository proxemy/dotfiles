
""""""""""""""""""""""""""
" Vundle - Plugin Manager
""""""""""""""""""""""""""

let s:plug_home = expand('~/.vim/bundle/')
let s:plug_dirs = {
	\ 'vundle':		s:plug_home . 'Vundle.vim',
	\ 'YCM':		s:plug_home . 'YouCompleteMe',
	\ 'syntastic':	s:plug_home . 'syntastic'
\ }
function! s:plug_exists(name)
	return isdirectory(s:plug_dirs[a:name])
endfunction


if ! s:plug_exists('vundle')

	if executable('git')
		echom "Cloning Vundle from git repository. Use ':PluginInstall' to fetch the plugins."
		call system('git clone https://github.com/VundleVim/Vundle.vim.git ' . s:vundle_dir)
	else
		echoerr "Can't clone Vundle! git is not installed."
	endif

else

	set nocompatible	" be iMproved, required as first command
	filetype off		" required

	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	" Keep Plugin commands between vundle#begin/end.
	" use :PluginInstall to install listed repos

	Plugin 'git://github.com/powerline/powerline'
	Plugin 'git://github.com/Valloric/YouCompleteMe'
	Plugin 'git://github.com/tpope/vim-surround'
	Plugin 'git://github.com/vim-syntastic/syntastic'
	"Plugin 'vim-airline/vim-airline'	" lightweight alterniative to powerline

	" All of your Plugins must be added before the following line
	call vundle#end()	" required

endif



""""""""""""""""""""""""""
"   Settings
""""""""""""""""""""""""""

set incsearch		" interactive search
set nocompatible	" disable vi compatibility
set number			" show line numbers
set backspace=indent,eol,start	" allows BS to delete these characters
set autoindent		" use indentation of the previous line
set cindent			" use c snytax indentation
set smartindent
set history=200
set undolevels=200
set ruler			" show cursor position in the lower right
"set cursorline		" unterline/show the current cursorline
set showcmd			" show command while typing
"filetype plugin indent on	" recognizing file types, loads plugins (if exit) and detects indentation style
"set spell			" spell checker (en)
"set spl=en			" spell check language
set smd				" show mode (normal, insert, replace, visual) when switching
set verbose=0		" verboselevel to show startup/exit vim processes, default: 11.
set more			" show '--more--' in listings
"set eol				" puts an eol at the last line in file
"set fixeol			" fix missing eol at the end of file
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



" tabs/spaces indentation
set tabstop=4		" tabstop = tabwidth
set shiftwidth=4	" one foldlevel = 4 chars (tab_size=8 wont fold properly)
"set softtabstop=0
set noexpandtab



" disable backups and swaps, just save one file
set nobackup
set nowritebackup
set noswapfile



" show tabs and eol as chars:
scriptencoding utf-8
set listchars=tab:▸\ ,eol:¬,trail:·
set list " display non-printable characters as above



"match ErrorMsg '\%>120v.\+'
match ErrorMsg '\s\+$'



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
	syntax enable		" syntax highlighting without overwriting existing settings

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



""""""""""""""""""""""""""
"	Plugin Config
""""""""""""""""""""""""""

if s:plug_exists('YCM')
	let g:ycm_show_diagnostics_ui = 0 " needed because YCM disables all syntastic checkers by default
endif

if s:plug_exists('syntastic')
	let g:syntastic_aggregate_errors = 1 " show error from all checkers
	let g:syntastic_cpp_compiler = 'g++'
	let g:syntastic_cpp_compiler_options = ' -std=c++1z -stdlib=libc++'

	" pip3 install neovim pynvim flake8 jedi autopep8
	let g:syntastic_python_checkers=['flake8', 'python3']
	let g:syntastic_python_flake8_args='--ignore W,E117,E201,E202,E203,E226,E228,E242,E261,E302,E303,E128,E124,E731,E265,E722'

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0

endif


function! Get_git_branch()
	let g_o = systemlist('cd '.expand('%:p:h:S').' && git branch 2>/dev/null')
	let b:git_branch = len(g_o) > 0 ? strpart(get(g_o,0,''),2) : ''
endfunc
autocmd BufEnter,BufWritePost * call Get_git_branch()


if has('statusline')
	set laststatus=2		" always show a status line
	set statusline=
	set statusline+=%y		" file type
	set statusline+=\ <%{b:git_branch}>
	set statusline+=%#warningmsg#	" set the background color green
	if s:plug_exists('syntastic')
		set statusline+=%{SyntasticStatuslineFlag()}
	endif
	set statusline+=%#Normal#		" sets the default background color
	set statusline+=%=				" splits between left and right side
	set statusline+=col:%c
endif



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



" set exrc		" vim executes a local .vimrc file for project specific settings
set secure		" limit the autoexec feature from "exrc" for security considerations

" you can enter ":make" to execute make in the current directory.
" this specifies a target directory
set makeprg=make\ -C\ ../build\ -j4

"set pastetoggle=<F2>
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

" easier moving/indenting of lines/blocks
vnoremap < <gv	" right
vnoremap > >gv	" left

" Automatic relaoding of .vimrc
autocmd! bufwritepost ~/.vimrc source %


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

endif



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

