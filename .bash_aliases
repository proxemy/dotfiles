set -o vi

export LC_ALL=en_US.UTF-8
export PS1="\
\[\e[1;30m\]\t\[\e[0m\] \
\[\e[1;35m\]\u\[\e[0m\]@\
\[\e[1;36m\]\H\[\e[0m\]:\
\[\e[1;32m\]\w\[\e[0m\]\
\$(ret=\$?; [ \$ret -ne 0 ] && echo \>\e[1\;31m\e[41m\$ret\e[m)\
\[\e[1;32m\]\n$ \[\e[0m\]"
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

# parameterized commands
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias grep='grep --color=always'
alias ml='mount -l | column -t'
alias gdb='gdb --tui'
alias sudo='sudo -E'
alias tmux='tmux -2'
alias tree='tree -C'

# new commands as aliases
alias edit='vim'
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'
alias fix_stty='stty sane'
alias psall='ps auxf | sort -nr -k 4'
alias noexif='exiftool -all='
alias timestamp='date +%F_%H-%M-%S%z'
alias taill='tail -f $(find /var/log -type f -name "*.*" ! -name "*.journal*" 2>&-)'
alias svndiff='svn diff --git --patch-compatible | vim -'

alias    cd..='cd ../'
alias      ..='cd ../'
alias      .2='cd ../../'
alias     ...='cd ../../'
alias      .3='cd ../../../'
alias    ....='cd ../../../'
alias      .4='cd ../../../../'
alias   .....='cd ../../../../'
alias      .5='cd ../../../../../'
alias  ......='cd ../../../../../'
alias      .6='cd ../../../../../../'
alias .......='cd ../../../../../../'


bin_exists nvim    && alias vim='nvim'
bin_exists nix     && alias nix-repl='nix repl "<nixpkgs>" "<nixpkgs/nixos>"'
bin_exists ss      && alias ports='ss -tulpan'
bin_exists netstat && alias ports='netstat -tulanp'


mcd() { mkdir -p "$1" && cd "$1"; }	# mcd: Makes new Dir and jumps inside
cd() { builtin cd "$@"; l; }		# Always list directory contents upon 'cd'
maxprio() {
	p=$(pidof "$1") || return 1
	sudo renice -n -15 $p || echo "renice failed."
	sudo chrt -f -p 99 $p || echo "chrt failed."
	sudo ionice -c 1 -n 0 -p $p || echo "ionice failed."
}
dl() { wget -nv -bcT 10 -a wget.log "$(echo $@ | sed 's/?.*$//g')"; }


# cvlc local network streaming
alias get_paudio_monitor='pactl list | grep "Monitor Source" | cut -d" " -f3'
alias stream-video='nice -10 cvlc -vvv screen:// --screen-fps=30.000000 --input-slave=pulse://$(get_paudio_monitor) --live-caching=300 --no-sout-all --sout-keep --play-and-exit --sout "#transcode{vcodec=h264,vb=8192,scale=0.5,acodec=mp3,ab=192,channels=2,samplerate=44100,scodec=none}:http{mux=ffmpeg{mux=flv},dst=:8888/v.mp4}"'
alias stream-audio='nice -10 cvlc -vvv pulse://$(get_paudio_monitor) --sout "#transcode{acodec=mp3,ab=128,channels=2}:http{dst=:8888/a.mp3}"'


umask 0077


if bin_exists tmux && [ -z "$TMUX" ] ; then
	tmux attach || tmux new
fi
