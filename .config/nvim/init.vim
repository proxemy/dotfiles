
" disable nvims cursor reshaping
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
set guicursor=

" set the config files/dirs as nvim's
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
