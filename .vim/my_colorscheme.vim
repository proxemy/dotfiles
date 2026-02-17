hi clear Error
hi Error
	\ ctermfg=Black guifg=Black
	\ ctermbg=Red guibg=Red
	"\ term=underline cterm=underline gui=underline

hi ColorColumn
	\ term=reverse cterm=reverse gui=reverse
	\ ctermbg=DarkGray guibg=DarkGray

" normal text background
hi Normal ctermbg=Black guibg=Black

hi NonText
	\ term=bold cterm=bold gui=bold
	\ ctermfg=DarkGray guifg=DarkGray

hi LineNr
	\ term=bold cterm=bold gui=bold
	\ ctermfg=DarkYellow guifg=DarkYellow

hi Comment ctermfg=DarkGray guifg=DarkGray

hi Folded
	\ term=underline cterm=underline gui=underline
	\ ctermfg=Black ctermbg=DarkGray
	\ guifg=Black guibg=DarkGray

hi SpecialKey term=NONE cterm=NONE gui=NONE ctermfg=DarkGray guifg=DarkGray

hi clear Search
hi Search term=reverse cterm=reverse gui=reverse

" enable a cursorline when in insert mode
set cursorline
hi CursorLine term=None cterm=None ctermbg=None guibg=None

"autocmd InsertEnter * highlight CursorLine cterm=Underline
"autocmd InsertLeave * highlight CursorLine cterm=None
