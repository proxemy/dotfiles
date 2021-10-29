export LC_ALL=en_US.UTF-8
export HISTIGNORE='pwd,exit,fg,bg,clear,jobs,l,ll,lll,history'
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND};history -c;history -a;history -r"
export PAGER='less'
export LESS='-FSri -j.5'
export EDITOR='vim'

# helper functions
bin_exists() { type "$@" > /dev/null 2>&-; }


# curl -s https://raw.githubusercontent.com/proxemy/dotfiles/master/.bash_aliases | sed '1,/^###/d;/^###/,$d;s/^# //g' | sh
### BEGIN dotfiles-init
alias dotfiles='env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'	# dotfiles directory swap
# set -e
# dotfiles clone --bare --depth=1 https://github.com/proxemy/dotfiles
# mv $HOME/dotfiles.git $HOME/.dotfiles
# dotfiles config status.showUntrackedFiles no
# dotfiles reset --hard
### END dotfiles-init


alias l='ls -CFh --color=always --group-directories-first'
alias ll='l -Glp'
alias lll='ll -FAZ'
alias ls='ls -GFhl --color=always'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias grep='grep --color=always'
alias ml='mount -l | column -t'
alias gdb='gdb --tui'
alias sudo='sudo -E'
alias taill='tail -f $(find /var/log -type f 2>&-)'
alias nix-repl='nix repl "<nixpkgs>" "<nixpkgs/nixos>"'



mcd() { mkdir -p "$1" && cd "$1"; }	# mcd: Makes new Dir and jumps inside
cd() { builtin cd "$@"; l; }		# Always list directory contents upon 'cd'
maxprio() {
	p=$(pidof "$1") || return
	sudo renice -n -15 $p || echo "renice failed."
	sudo chrt -f -p 99 $p || echo "chrt failed."
	sudo ionice -c 1 -n 0 -p $p || echo "ionice failed."
}
dl() { wget -nvbcT 10 -a wget.log "$(echo $@ | sed 's/?.*$//g')"; }


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
alias psall='ps auxf | sort -nr -k 4'
alias noexif='exiftool -all='
alias tmux='tmux -2'
alias timestamp='date +%F_%H-%M-%S%z'

if bin_exists ss; then
	alias ports='ss -tulpan'
elif bin_exists netstat; then
	alias ports='netstat -tulanp'
fi

alias stream-desktop-video='cvlc screen:// --screen-fps=30.000000 --input-slave=pulse://alsa_output.pci-0000_00_1b.0.analog-stereo.monitor --live-caching=300 --no-sout-all --sout-keep --play-and-exit --sout="#transcode{vcodec=h264,vb=8192,scale=0.5,acodec=mp3,ab=192,channels=2,samplerate=44100,scodec=none}:http{mux=ffmpeg{mux=flv},dst=:8884/}"'



umask 0077


if bin_exists tmux && [ -z "$TMUX" ] ; then
	tmux attach || tmux new
fi
