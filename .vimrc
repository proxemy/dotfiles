set encoding=utf-8
set visualbell

""""""""""""""""""""""""""
" Vundle - Plugin Manager
""""""""""""""""""""""""""

let s:plug_home = expand('~/.vim/bundle/')
let s:plug_dirs = {
	\ 'vundle':		s:plug_home . 'Vundle.vim',
	\ 'YCM':		s:plug_home . 'YouCompleteMe',
	\ 'tree-sitter':s:plug_home . 'nvim-treesitter',
	\ 'syntastic':  s:plug_home . 'syntastic',
\ }
function! s:plug_exists(name)
	return isdirectory(s:plug_dirs[a:name])
endfunction


if ! s:plug_exists('vundle')

	if executable('git')
		echom "Cloning Vundle from git repository. Use ':PluginInstall' to fetch the plugins."
		call system('git clone https://github.com/VundleVim/Vundle.vim.git ' . s:plug_dirs['vundle'])
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

	Plugin 'ycm-core/YouCompleteMe' , { 'oninstall': './install.py --clang-completer --rust-completer' }
	" TO INSTALL RUST LSP:
	" rustup component add rls rust-analysis rust-src
	" ln -s ~/.rustup/toolchains/*x86_64-unknown-linux-gnu/ ./rls
	" ALT: ./install.py --rust-completer --rust-toolchain-version stable-x86_64-unknown-linux-gnu

	Plugin 'https://github.com/nvim-treesitter/nvim-treesitter' , { 'do': ':TSUpdate' }

	" deprecated syntax checker and error display, superseded by treesitter
	Plugin 'https://github.com/vim-syntastic/syntastic'

	" custom syntax highlighting superseded by treesitter language modules
	"Plugin 'https://github.com/LnL7/vim-nix'
	Plugin 'https://github.com/rust-lang/rust.vim'

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
set nocindent nosmartindent " disable dreaded comment unindentation
set history=200
set undolevels=200
set ruler			" show cursor position in the lower right
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

" This function delivers the string to be displayed over folded lines
function MyFoldText()
	let indent = indent(v:foldstart)
    return repeat(' ', indent + &sw-4) . trim(getline(v:foldstart))
endfunction
set foldtext=MyFoldText()

" tree-sitter folding or by fold by indentation
if s:plug_exists('tree-sitter')
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
else
	echom "tree-sitter plugin not found."
	set foldmethod=indent
endif
set nofoldenable	" dont fold by default
set foldcolumn=3	" shows a fold column on the lest (symbols: +. -, |)
set fillchars=fold:\ " disable 'fillchars' in 'foldtext' lines
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


" Netrw¬
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_cursor=3
let g:netrw_sizestyle="H"
"let g:netrw_browse_split=4¬
"let g:netrw_altv=1¬
"let g:netrw_winsize=25
"

""""""""""""""""""""""""""
"	Colors
""""""""""""""""""""""""""
" only turn on colors if terminal supports it
if &t_Co > 2 || has('gui_rendering')

	" set the color column to show/delimit line length
	set colorcolumn=80
	highlight ColorColumn ctermbg=darkgrey guibg=darkgrey cterm=reverse gui=reverse

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
	hi Folded term=underline ctermfg=White ctermbg=DarkGray
	hi NonText term=bold cterm=bold ctermfg=DarkGray
	hi SpecialKey term=NONE cterm=NONE ctermfg=DarkGray
	hi clear Search
	hi Search term=reverse cterm=reverse

	" enable a cursorline when in insert mode
	set cursorline
	hi CursorLine term=None cterm=None ctermbg=None
	"autocmd InsertEnter * highlight CursorLine cterm=Underline
	"autocmd InsertLeave * highlight CursorLine cterm=None
endif



""""""""""""""""""""""""""
"	Plugin Config
""""""""""""""""""""""""""

if s:plug_exists('YCM')
	let g:ycm_show_diagnostics_ui = 0 " needed because YCM disables all syntastic checkers by default
	let g:ycm_autoclose_preview_window_after_completion = 1
	let g:ycm_max_num_candidates = 0 " unlimited autocomplete popup list
endif

if s:plug_exists('syntastic')
	let g:syntastic_cpp_compiler = 'g++'
	let g:syntastic_cpp_compiler_options = ' -std=c++1z -stdlib=libc++'

	" pip3 install neovim pynvim flake8 jedi autopep8
	let g:syntastic_python_checkers=['flake8', 'python3']
	let g:syntastic_python_flake8_args='--ignore W191,W391,E117,E201,E202,E203,E226,E228,E242,E261,E302,E303,E128,E124,E731,E265,E222,E722,E221,E241,E305,E501'

	"general options
	let g:syntastic_auto_jump = 3 " jump to first error in file
	let g:syntastic_aggregate_errors = 1 " show error from all checkers
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0

	" dynamic loclist size
	" see :h syntastic-loclist-callback
	function! SyntasticCheckHook(errors)
		if !empty(a:errors)
			let g:syntastic_loc_list_height = min([len(a:errors), 10])
		endif
	endfunction
endif

let g:git_branch = 'non-git'
function! Get_git_branch()
	let g_o = systemlist('cd '.expand('%:p:h:S').' && git branch 2>/dev/null')
	let g:git_branch = len(g_o) > 0 ? strpart(get(g_o,0,''),2) : 'non-git'
endfunc
autocmd BufEnter,BufWritePost * call Get_git_branch()


if has('statusline')
	highlight StatusLineMiddle cterm=underline
	set laststatus=2		" always show a status line
	set stl=[%Y,%{&fileencoding?&fileencoding:&encoding}] " file type/enc
	set stl+=<%{g:git_branch}>
	set stl+=%#StatusLineMiddle#%=%0*%l/%L:%c\ %p%% " shows file location stuff, right
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
set clipboard=unnamedplus " Use the system clipboard

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

