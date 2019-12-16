# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source things I don't want to put on github
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

if [ -f ~/.shell_prompt.sh ]; then
	source ~/.shell_prompt.sh
fi

# User specific aliases and functions
alias ll='ls -l'
alias lf='ls -AF'
alias gl="git log -n 800 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %an' --abbrev-commit --date=relative"
alias g='git'
alias d='date --rfc-3339 date -d'
alias t='todo -t'

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set editing-mode vi'
export EDITOR=vim
alias ci=vi

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin
