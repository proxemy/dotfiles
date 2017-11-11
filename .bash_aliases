alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'	# dotfiles directory swap


alias l='ls -CFh --color=auto'		# Preferred 'ls' implementation
alias ll='ls -FGlAhp --color=auto'
alias ls='ls -GFhl --color=auto'
alias cp='cp -iv'		# Preferred 'cp' implementation
alias mv='mv -iv'		# Preferred 'mv' implementation
alias mkdir='mkdir -pv'		# Preferred 'mkdir' implementation
alias less='less -FSRXc'	# Preferred 'less' implementation



mcd() { mkdir -p "$1" && cd "$1"; }	# mcd: Makes new Dir and jumps inside
cd() { builtin cd "$@"; l; }		# Always list directory contents upon 'cd'


alias cd..='cd ../'			# Go back 1 directory level (for fast typers)
alias ..='cd ../'			# Go back 1 directory level
alias ...='cd ../../'			# Go back 2 directory levels
alias .3='cd ../../../'			# Go back 3 directory levels
alias .4='cd ../../../../'		# Go back 4 directory levels
alias .5='cd ../../../../../'		# Go back 5 directory levels
alias .6='cd ../../../../../../'	# Go back 6 directory levels
alias ~="cd ~"				# ~: Go Home



alias edit='vim'			# edit: Opens any file in sublime editor
alias c='clear'				# c: Clear terminal display
alias which='type -all'			# which: Find executables
alias path='echo -e ${PATH//:/\\n}'	# path: Echo all executable Paths

alias fix_stty='stty sane'		# fix_stty: Restore terminal settings when screwed up

