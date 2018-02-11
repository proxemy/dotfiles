

" enable doxygen highlighting for c/c++


augroup project
	autocmd!
	autocmd BufRead,BufNewFile *.hpp,*.cpp,*.h,*.c set filetype=c.doxygen
augroup END
