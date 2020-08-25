export LC_ALL=en_US.UTF-8

# helper functions, will get unset in the end
bin_exists() { type "$@" > /dev/null 2>&1; }


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



mcd() { mkdir -p "$1" && cd "$1"; }	# mcd: Makes new Dir and jumps inside
cd() { builtin cd "$@"; l; }		# Always list directory contents upon 'cd'


alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias ~='cd ~'

if bin_exists nvim; then
	alias vim='nvim';
fi
alias edit='vim'
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'

alias fix_stty='stty sane'
alias ports='netstat -tulanp'
alias psall='ps auxf | sort -nr -k 4'
alias noexif='exiftool -all='
alias tmux='tmux -2'
alias timestamp='date +%F_%H-%M-%S%z'

alias stream-desktop-video='cvlc screen:// --screen-fps=30.000000 --input-slave=pulse://alsa_output.pci-0000_00_1b.0.analog-stereo.monitor --live-caching=300 --no-sout-all --sout-keep --play-and-exit --sout="#transcode{vcodec=h264,vb=8192,scale=0.5,acodec=mp3,ab=192,channels=2,samplerate=44100,scodec=none}:http{mux=ffmpeg{mux=flv},dst=:8884/}"'



# cleanup
unset -f bin_exists
