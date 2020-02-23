
#### setup dotfiles
alias dotfiles='env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'	# dotfiles directory swap
# dotfiles init
# dotfiles config status.showUntrackedFiles no
# dotfiles remote add origin https://github.com/proxemy/dotfiles
# dotfiles pull origin master
# dotfiles branch --set-upstream-to origin/master


alias l='ls -CFh --color=auto'
alias ll='ls -FGlAhp --color=auto'
alias ls='ls -GFhl --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias less='less -FSRXc'
alias watch='watch ' # space enables alias expansion for the following arg



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


alias vim='nvim'
alias edit='nvim'			# edit: Opens any file in sublime editor
alias which='type -all'			# which: Find executables
alias path='echo -e ${PATH//:/\\n}'	# path: Echo all executable Paths

alias fix_stty='stty sane'		# fix_stty: Restore terminal settings when screwed up
alias ports='netstat -tulanp'	# show open ports
alias psall='ps auxf | sort -nr -k 4'
alias noexif='exiftool -all='

alias tmux='tmux -2'
